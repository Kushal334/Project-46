//
//  FirstViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GenericConnctionDelgeate {

    
    var data = [String : String]()
    var imageArraay = [Image]()
    
    @IBOutlet weak var movieTextField: UITextField!
    
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var yearLabel: UILabel!
    
    var URL = ""
    //movie.php?action=find&search=iron
    
    lazy var apiController : GenericConnection = GenericConnection(delegate: self)

    var years = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populatePickerView()
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButton(sender: AnyObject) {
        
        var searchField = self.movieTextField.text!
        
        if !self.yearLabel.text!.isEmpty {
            searchField += " \(self.yearLabel.text!)"
        }
        
        
        self.data["action"] = "find"
        self.data["search"] = searchField
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: URL, view: self.view)
        
    }

    //GenericConnectionDelegate
    
    func didFinishUpload(result: NSData) {
     
        do {
            
            let feeds = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSArray
            
            for feed in feeds {
                
                let image = Image()
                
                image.setImage(feed["imageLink"] as! String)
                image.setLink(feed["movieLink"] as! String)
                self.imageArraay.append(image)
            }
            
            
        }  catch let parseError {
            print(parseError)
            
            let alert = UIAlertController(title: "Error", message:"", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
            
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }
        
        self.movieTextField.text = ""
        self.yearLabel.text = "Year"
        self.yearLabel.textColor = UIColor.lightGrayColor()

        
        if self.imageArraay.count > 0 {
            self.performSegueWithIdentifier("movieSegue", sender: self)
            
        } else {
            
            let alert = UIAlertController(title: "Error", message:"No movies found", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.DismissKeyboard()
    }
    func DismissKeyboard(){
        view.endEditing(true)
    }

    
    // UIPickerController Methods
    
    //MARK: - Delegates and data sources
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - Delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.yearLabel.textColor = UIColor.blueColor()
        self.yearLabel.text = self.years[row]
        
    }
   
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    
    func populatePickerView() {
        
        for(var i = 2016; i > 1940; i-- ) {
            let string = String(i)
             years.append(string)
        }
    }
    
    
    //MARK: Segue Delegate
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "movieSegue") {
            
            let subVC: PickMovieCollectionViewController = segue.destinationViewController as! PickMovieCollectionViewController
            subVC.movieArray = self.imageArraay
        }
        
    }

}
