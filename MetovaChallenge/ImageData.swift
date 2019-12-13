//
//  ImageData.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation

struct ImageData : Codable {
    var id: String?
    var description: String?
    var alt_description: String?
    var urls: URLData
    var likes: Int
}


struct URLData : Codable {
    var regular: String?
    var thumb: String?
}

