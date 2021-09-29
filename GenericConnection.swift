//
//  GenericConnection.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import Foundation

protocol GenericConnctionDelgeate {
    
    func didFinishUpload(result: NSData)
}

import Foundation
import UIKit

class GenericConnection: NSObject,NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate   {
    
    var delegate: GenericConnctionDelgeate?
    var returnMessage: String
    var view: UIView?
    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var task: NSURLSessionTask?
    
    init(delegate: GenericConnctionDelgeate?) {
        self.delegate = delegate
        self.returnMessage  = ""
    }
    
    
    func urlRequest( param: NSDictionary, URL: String,view: UIView)
    {
        
        self.view = view
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView?.transform = CGAffineTransformMakeScale(1.0, 3.0)
        progressView?.layer.cornerRadius = self.progressView!.frame.height / 2
        progressView?.clipsToBounds = true
        progressView?.center = self.view!.center
        self.view!.addSubview(progressView!)
        
        // Add Label
        progressLabel = UILabel()
        progressLabel!.frame = CGRectMake(0,0, 100, 50)
        progressLabel!.textAlignment = .Center
        progressLabel!.center = CGPoint(x: self.view!.frame.width / 2 , y: (self.view!.frame.height / 2) - 50)
        self.view!.addSubview(progressLabel!)
        
        let paramString = param.stringFromHttpParameters()
        
        let urlString = URL + paramString
        
        let data = urlString
        
        let myUrl = NSURL(string: urlString)
        
        print(data)
        
        let request = NSMutableURLRequest(URL:myUrl!)

        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        self.task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                //     println("error=\(error)")
            }
            
            if let uploadProjectDelegate = self.delegate {
                dispatch_async(dispatch_get_main_queue()) {
                    self.progressLabel?.removeFromSuperview()
                    self.progressView?.removeFromSuperview()
                    uploadProjectDelegate.didFinishUpload(data!)
                }
            }
        }
        
        self.task!.resume()
        
    }
    
    func cancelUpload() {
        self.task!.cancel()
        self.progressLabel?.removeFromSuperview()
        self.progressView?.removeFromSuperview()
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {

        
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        //println(uploadProgress)
        self.progressView!.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        self.progressLabel!.text = "\(progressPercent)%"
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        //self.uploadButton.enabled = true
        self.progressLabel?.removeFromSuperview()
        self.progressView?.removeFromSuperview()
    }
    
}


extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

extension NSDictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).URLEncoded()
            let percentEscapedValue = (value as! String).URLEncoded()
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }

}

extension String {
    
    func URLEncoded() -> String {
        
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        
        characters.removeCharactersInString("&")
        
        guard let encodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(characters) else {
            return self
        }
        
        return encodedString
        
    }
    
}

extension Character {
    
    func toInt() -> Int? {
        return Int(String(self))
    }
    
}
