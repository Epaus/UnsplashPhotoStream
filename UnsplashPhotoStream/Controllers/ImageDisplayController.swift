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
    var imageTitle: String?
    
    @IBOutlet weak var imageView: UIImageView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(hideActivityIndicator), name:.ImageViewSetNotification, object: nil)
        self.view.addSubview(activityIndicator)
    }
    
    func configureNavigationBar() {
       navigationItem.title = imageTitle ?? ""
        self.navigationItem.largeTitleDisplayMode = .never
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.text = imageTitle ?? ""
        self.navigationItem.titleView = label
    }

    
    @objc func hideActivityIndicator() {
        activityIndicator.hideActivityIndicator()
    }
    
}
