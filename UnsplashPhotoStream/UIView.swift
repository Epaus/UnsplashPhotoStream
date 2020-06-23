//
//  UIView.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/15/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
