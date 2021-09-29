//
//  WebViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "https://www.imdb.com")
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
