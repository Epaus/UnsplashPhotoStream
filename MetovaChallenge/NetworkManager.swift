//
//  NetworkManager.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkManagerDelegate {
    func didUpdateImages( imageModels: [ImageModel])
    func didFailUpdate(error: Error)
}

struct NetworkManager {
    
    init() {
        print("NetworkManager initializer")
    }
    
    var delegate: NetworkManagerDelegate?
    let unsplashURL = "https://api.unsplash.com/photos/?client_id=479b3f025820451936d039e20383dde0bfefac1bad05a06276e348d0fcb36f09"
    
    func fetchSearchText(searchText: String) {
        let urlString = "\(unsplashURL)&q=\(searchText)"
        
        print("urlString = ", urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if  error != nil  {
                    self.delegate?.didFailUpdate(error: error!)
                    return
                }
                if let jsonData = data,
                    let imageModelArray = self.parseJSON(jsonData) {
                    if let delegate = self.delegate {
                        delegate.didUpdateImages(imageModels: imageModelArray)
                    } else {
                        print("delegate is nil")
                    }
                }
            }
            task.resume()
        }
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
