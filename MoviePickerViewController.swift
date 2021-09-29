//
//  MoviePickerViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 07/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class MoviePickerViewController: UIViewController {

    var movieArray = [Image]()
    var imageCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlToImage(movieArray[0].getImage())
        
        print(movieArray.count)
    }
    
    
    func setUpImageViews() {
        
        
        
    }
    
    func urlToImage(urlString:String) {
        
        let imgURL = NSURL(string: urlString)
        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.movieImageView.image = image
                    
                })
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
