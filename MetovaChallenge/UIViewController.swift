//
//  UIViewController.swift
//  MetovaChallenge
//
//  Created by Estelle Paus on 12/16/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
