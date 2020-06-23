//
//  ActivityIndicatorView.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/15/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    var blurView: UIView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showActivityIndicator(uiView: UIView) {
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = uiView.frame
        blurView.center = uiView.center
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = uiView.center
        activityIndicator.color = .darkGray
        
        uiView.addSubview(blurView)
        uiView.addSubview(activityIndicator)
        start()
    }
    
    func start() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.blurView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
    }
    
}
