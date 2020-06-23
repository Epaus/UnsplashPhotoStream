//
//  ImageModel.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

struct ImageModel {
    let id: String?
    let description: String?
    let alt_description: String?
    let regularURL: String?
    let thumbnailURL: String?
    var likes: Int
    
    func stripURL(url:String) -> String {
        var newURL = String()
      
        if let index = url.range(of: "?")?.lowerBound {
            let substring = url[..<index]
            newURL = String(substring)
        }
        return newURL
    }
}
