//
//  ImageDisplayController.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/15/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class ImageDisplayController: UIViewController {
    
    var imageURL = String()
    lazy var activityIndicator = ActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(hideActivityIndicator), name:.ImageViewSetNotification, object: nil)
        self.view.addSubview(activityIndicator)
    }
    
    @objc func hideActivityIndicator() {
        activityIndicator.hideActivityIndicator()
    }
    
}