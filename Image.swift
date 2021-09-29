//
//  Image.swift
//  Media Center
//
//  Created by Timothy Barnard on 07/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import Foundation

class Image {
    
    var imageLink:String?
    var movieLink:String?
    
    init() {
        
    }
    
    func getImage()->String {
        return self.imageLink!
    }
    func setImage(image:String) {
        self.imageLink = image
    }
    
    func getLink()->String {
        return self.movieLink!
    }
    
    func setLink(link:String){
        self.movieLink = link
    }
    
}