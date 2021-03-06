//
//  ImageListTableViewCell.swift
//  UnsplashPhotoStream
//
//  Created by Estelle Paus on 12/14/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailPhotoView: UIImageView!  
    @IBOutlet weak var descriptionLabel: UILabel!
   
    
    var model : ImageModel? {
        didSet {
            descriptionLabel.text = model?.description ?? model?.alt_description ?? "no description found"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
