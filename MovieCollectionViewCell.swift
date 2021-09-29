//
//  MovieCollectionViewCell.swift
//  Media Center
//
//  Created by Timothy Barnard on 08/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String!
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    
}
