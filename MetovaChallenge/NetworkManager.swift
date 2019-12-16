//
//  NetworkManager.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import UIKit
import os.log

enum RequestError: Error {
    case invalidURL, noHTTPResponse, http(status: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noHTTPResponse:
            return "Not a HTTP response."
        case .http(let status):
            return "HTTP error: \(status)."
        }
    }
}

enum Method: String {
    case get, post, put, delete
}

enum QueryType {
       case body
       case path
   }

protocol NetworkManagerDelegate {
    func didUpdateImages( imageModels: [ImageModel])
    func didFailUpdate(error: Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    let splashURL = "https://api.unsplash.com"
    var endpoint = "/photos" //"/collections/317099/photos"
    var type: QueryType { return .path }
    var timeoutInterval = 30.0
    
    // accessKey should be store in a config file - but first things first
    var accessKey = "479b3f025820451936d039e20383dde0bfefac1bad05a06276e348d0fcb36f09"
    var method: Method { return .get }
    private var task: URLSessionDataTask?
    var searchParameter = String()
    
    var models:  [ImageModel] = [] {
        didSet {
            NotificationCenter.default.post(name: .ImageModelListUpdatedNotification, object: models )
        }
    }
    var delegate: NetworkManagerDelegate?

    func fetchSearchText(searchText: String) {
        
        if searchText != "" {
            searchParameter = searchText
            endpoint = "/search/photos"
        } else {
            searchParameter = ""
            endpoint = "/photos"
        }
       
        performRequest(with: splashURL)
    }
    func performRequest(with urlString: String ) {
        guard var request = try? prepareURLRequest() else {
            os_log("failed to prepare URLRequest")
            return
        }
        
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = method.rawValue
        
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let jsonData = data {
                if self.searchParameter == "" {
                    self.models  = self.parseJSON(jsonData) ?? [ImageModel]()
                } else {
                    self.models = self.parseOuterResponse(data: jsonData) ?? self.models
                }
                
               
            }
        })
        task?.resume()
    }
    
    func prepareHeaders() -> [String: String]? {
           var headers = [String: String]()
           headers["Authorization"] = "Client-ID \(accessKey)"
           return headers
       }
    
    func prepareURLRequest() throws -> URLRequest {
        
        var parameters = ["per_page":30, "page":1 ] as [String : Any]
        if searchParameter.count > 0 {
            parameters["query"] = searchParameter
        }
        
        guard let url = prepareURLComponents()?.url else {
            throw RequestError.invalidURL
        }
        
        switch type {
        case .body:
            var mutableRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
                mutableRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
               
            
            return mutableRequest

        case .path:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = queryParameters(parameters)
            let urlRequest = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            return urlRequest
        }
    }
    
    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
           var allowedCharacterSet = CharacterSet.alphanumerics
           allowedCharacterSet.insert(charactersIn: ".-_")

           var query = ""
           parameters?.forEach { key, value in
               let encodedValue: String
             
               if let value = value as? String {
                   encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
               } else {
                   encodedValue = "\(value)"
               }
               query = "\(query)\(key)=\(encodedValue)&"
           }
           
           return query
       }
    
    func prepareURLComponents() -> URLComponents? {
        guard let apiURL = URL(string: self.splashURL) else {
               return nil
           }
           var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)
           urlComponents?.path = endpoint
           return urlComponents
       }
    
    func parseOuterResponse(data: Data) -> [ImageModel]? {
        var jsonResponse:Any
        do {
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            let jResponse = jsonResponse as? [String: Any]
            let imageArray = [ImageModel]()
            let results = jResponse?["results"]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: results as Any, options: [])
                return self.parseJSON(data)
                
            } catch  {
                 os_log("JSONSerialization error %@",error.localizedDescription)
            }
            return imageArray
            
        } catch {
            os_log("JSONSerialization error %@",error.localizedDescription)
        }
        
        return nil
    }
    
    func parseJSON(_ imageData: Data) -> [ImageModel]? {
        var imageArray = [ImageModel]()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ImageData].self, from: imageData)
            for data in decodedData {
               
                let id = data.id
                let description = data.description
                let alt_description = data.alt_description
                let url = data.urls
                let regular = url.regular
                let thumbnail = url.thumb
                let likes = data.likes
                
                let image = ImageModel(id: id, description: description, alt_description: alt_description, regularURL: regular, thumbnailURL: thumbnail, likes: likes)
                
                imageArray.append(image)
            }
            
            return imageArray
            
        } catch {
            delegate?.didFailUpdate(error: error)
            return nil
        }
    }
}
