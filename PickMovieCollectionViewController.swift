//
//  PickMovieCollectionViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 08/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

private let parallaxCellIdentifier = "parallaxCell"

class PickMovieCollectionViewController: UICollectionViewController, GenericConnctionDelgeate {

    var movieArray = [Image]()
    var data = [String : String]()
    var imageCache = Cache.images
    
    var URL = ""
    //movie.php?action=find&search=iron
    
    lazy var apiController : GenericConnection = GenericConnection(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        //self.collectionView!.registerClass(MovieCollectionViewCell.self, forCellWithReuseIdentifier: parallaxCellIdentifier)

        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.movieArray.removeAll()
        self.imageCache.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //GernericConnecitonDelegate
    
    func didFinishUpload(result: NSData) {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSDictionary
            
            let alert = UIAlertController(title: "", message:"", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                
            }
            
            if (json["success"] as? Int == 1) {
                alert.title = "Succesfull"
                
            } else  {
                alert.title = "Error"
            }
            
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }  catch let parseError {
            print(parseError)
            
            
        }
    }



    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        
        let alert = UIAlertController(title: "", message:"Start Downloading?", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
        
            self.data["action"] = "get"
            self.data["search"] = self.movieArray[indexPath.row].getLink()
        
            ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
            self.apiController.delegate = self
            self.apiController.urlRequest(self.data, URL: self.URL, view: self.view)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let parallaxCell = collectionView.dequeueReusableCellWithReuseIdentifier(parallaxCellIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
        
        
        if self.movieArray[indexPath.row].getImage() == "" {
            
            //parallaxCell.imageView.image = UIImage(named: "defaultImage@2x.png")
            
        } else {
            
            let imageIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            imageIndicator.frame = CGRectMake(parallaxCell.frame.width / 2, parallaxCell.frame.height / 2, 40, 40)
            imageIndicator.center = CGPoint(x: parallaxCell.frame.width / 2, y: parallaxCell.frame.height / 2)
            imageIndicator.hidesWhenStopped = true
            
            parallaxCell.backgroundColor = UIColor.grayColor()
            parallaxCell.addSubview(imageIndicator)
            
            parallaxCell.imageView.image = nil
            
            let urlString = self.movieArray[indexPath.row].getImage()
            
            parallaxCell.imageURL = urlString
            
            // If this image is already cached, don't re-download
            if let img = imageCache[urlString] {
                //println("not loading \(indexPath.row)")
                parallaxCell.imageView.image = img
            }
            else {
                // println("Loading \(indexPath.row)")
                imageIndicator.startAnimating()
                // The image isn't cached, download the img data
                // We should perform this in a background thread
                let URL = NSURL(string: self.movieArray[indexPath.row].getImage())
                let request: NSURLRequest = NSURLRequest(URL: URL!)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    
                    if error == nil {
                        
                        imageIndicator.stopAnimating()
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data!)
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? MovieCollectionViewCell {
                                cellToUpdate.imageView.image = image
                                //parallaxCell.imageView.image = image
                                
                            }
                        })
                    }
                    else {
                        //  println("Error: \(error.localizedDescription)")
                    }
                })
                
                
            }
        }
        return parallaxCell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        //        let frame : CGRect = self.view.frame
        //        let margin  = (frame.width - 90 * 3) / 6.0
        //        if(UIDevice.currentDevice().userInterfaceIdiom  == .Pad) {
        //            //return UIEdgeInsetsMake(0, 5, 0, 5) // margin between cells
        //        } else {
        
        return UIEdgeInsetsMake(0, 0, 0, 0) // margin between cells
        //}
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfCellInRow : Int = 2
        let padding : Int = 5
        let collectionCellWidth : CGFloat = (self.view.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
        return CGSize(width: collectionCellWidth , height: collectionCellWidth)
    }
}
