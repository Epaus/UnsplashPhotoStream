//
//  UIImageView.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/13/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import os.log

extension UIImageView {
    
    func getImage(name: String)  {
        let request = URL(string: name)
        URLSession.shared.dataTask(with: request!, completionHandler:  { (data, response, error)  in
            if error != nil {
                os_log("ERROR: %@", error!.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)!
                self.image = image
                NotificationCenter.default.post(name: .ImageViewSetNotification, object: nil )
            })
        }).resume()
    }
}
