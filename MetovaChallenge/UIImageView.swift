//
//  UIImageView.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImage(name: String)  {
        let request = URL(string: name)
        URLSession.shared.dataTask(with: request!, completionHandler:  { (data, response, error)  in
            if error != nil {
                print("ERROR: \(error!)")
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)!
                self.image = image
                print("I have an image")
                // appending the image to an array so that I only have to download it once.
                //Images.shared.images.append(image)

            })
        }).resume()
    }
}
