//
//  SecondViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GenericConnctionDelgeate {
    
    
    @IBOutlet weak var showName: UITextField!
    @IBOutlet weak var showSeason: UITextField!
    @IBOutlet weak var showEpisode: UITextField!
    @IBOutlet weak var addShow: UIButton!
    @IBOutlet weak var cancelUpdate: UIBarButtonItem!
    var refreshControl:UIRefreshControl!
    
    var editingMode = false
    var editingRow: Int?
    
    var URL = ""
    
    var data = [String : String]()
    var showArray = [Show]()
    var connection: Connection?
    
     lazy var apiController : GenericConnection = GenericConnection(delegate: self)
    
    enum Connection {
        case upload
        case download
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.collectionView?.addSubview(refreshControl)
       
        self.navigationItem.leftBarButtonItem = nil
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        
        self.data["action"] = "tv"
        self.data["tv"] = "bla"
        self.data["season"] = "1"
        self.data["episode"] = "1"
        self.data["avail"] = "1"
        self.data["db"] = "show"
        
        self.connection = Connection.download
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: URL, view: self.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didFinishUpload(result: NSData) {
        
        do {
            
            if self.connection == Connection.download {
                
                let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSArray
                
                for feeds in json {
                    
                    let newShow = Show()
                    newShow.setID(String(feeds["ID"] as! Int))
                    newShow.setName(feeds["Name"] as! String)
                    newShow.setSeason(String(feeds["Season"] as! Int))
                    newShow.setEpisode(String(feeds["Episode"] as! Int))
                    newShow.setAvail(feeds["Avail"] as! Int)
                    self.showArray.append(newShow)
                    
                }
                
                self.tableView.reloadData()
                
                
            } else {
                
                let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSDictionary
                
                let alert = UIAlertController(title: "", message:"", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    
                }
                
                if (json["success"] as? Bool == true) {
                    alert.title = "Added Succesfull"
                    self.tableView.reloadData()
                } else  {
                    alert.title = "Error in adding"
                }
                
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}

            }
            
            
        }  catch let parseError {
            print(parseError)
            
            
        }

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.DismissKeyboard()
    }
    func DismissKeyboard(){
        view.endEditing(true)
    }
    @IBAction func cancelUpdate(sender: AnyObject) {
        
        self.showName.text = ""
        self.showEpisode.text = ""
        self.showSeason.text = ""
        self.addShow.setTitle("Add", forState: .Normal)
        self.navigationItem.leftBarButtonItem = nil
        self.tableView.reloadData()
        
    }


    @IBAction func addShow(sender: AnyObject) {
        
        var dbAction = "add"
        var showAvial = "1"
        
        if editingMode {
            
            self.showArray[self.editingRow!].setName(self.showName.text!)
            self.showArray[self.editingRow!].setSeason(self.showSeason.text!)
            self.showArray[self.editingRow!].setEpisode(self.showEpisode.text!)
            showAvial = String(self.showArray[self.editingRow!].getAvail())
            dbAction = "edit"
            
        } else {
            
            let newShow = Show()
            newShow.setName(self.showName.text!)
            newShow.setSeason(self.showSeason.text!)
            newShow.setEpisode(self.showEpisode.text!)
            newShow.setAvail(1)
            self.showArray.append(newShow)
            dbAction = "add"
            showAvial = "1"
        }
        
       
        
        self.data["action"] = "addTV"
        self.data["tv"] = self.showName.text!
        self.data["season"] = self.showSeason.text!
        self.data["episode"] = self.showEpisode.text!
        self.data["avail"] = showAvial
        self.data["db"] = dbAction
        
        self.connection = Connection.upload
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: URL, view: self.view)
        
        self.editingMode = false
        
        self.showName.text = ""
        self.showEpisode.text = ""
        self.showSeason.text = ""
        self.addShow.setTitle("Add", forState: .Normal)
        self.navigationItem.leftBarButtonItem?.customView?.hidden = true

    }

    
    //MARK: TableView Delgates and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showsCell", forIndexPath: indexPath) as! ShowTableViewCell
        
        cell.showName.text = self.showArray[indexPath.row].getName()
        cell.showSeason.text = "S"+self.showArray[indexPath.row].getSeason()
        cell.showEpisode.text = "E"+self.showArray[indexPath.row].getEpisde()
        
        if (self.showArray[indexPath.row].getAvail() == 1) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        return indexPath
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        var watch_unwatch = ""
        var watchValue = "1"
        var watchDBAction = "continue"
        
        if(cell.accessoryType == .Checkmark) {
            watch_unwatch = "Unwatch"
            watchValue = "0"
            watchDBAction = "halt"
           
        } else {
            watch_unwatch = "Watch"
            watchValue = "1"
            watchDBAction = "continue"
           
        }
        
        let withdrawn = UITableViewRowAction(style: .Normal, title: "Remove") { action, index in
            self.updateTVShows(self.showArray[indexPath.row].getName(),
                showSeason: self.showArray[indexPath.row].getSeason(), showEpisode: self.showArray[indexPath.row].getEpisde(), showAvaiL: "1", dbAction: "delete")
            self.showArray.removeAtIndex(indexPath.row)
        }
        let share = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            self.showName.text = self.showArray[indexPath.row].getName()
            self.showSeason.text = self.showArray[indexPath.row].getSeason()
            self.showEpisode.text = self.showArray[indexPath.row].getEpisde()
            self.addShow.setTitle("Update", forState: .Normal)
            self.editingRow = indexPath.row
            self.editingMode = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelUpdate:")
        }
        let message = UITableViewRowAction(style: .Normal, title: watch_unwatch) { action, index in
            self.updateTVShows(self.showArray[indexPath.row].getName(),
                showSeason: self.showArray[indexPath.row].getSeason(), showEpisode: self.showArray[indexPath.row].getEpisde(), showAvaiL: watchValue, dbAction: watchDBAction)
           self.showArray[indexPath.row].setAvail(Int(watchValue)!)
            
        }
        message.backgroundColor = UIColor(red: 110.0/255.0, green: 197.0/255.0, blue: 233.0/255.0, alpha: 1)
        share.backgroundColor = UIColor(red: 255.0/255.0, green: 197.0/255.0, blue: 108.0/255.0, alpha: 1)
        withdrawn.backgroundColor = UIColor(red: 255.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1)
        
        return [withdrawn, message, share]
    }

    
    func updateTVShows(showName:String, showSeason:String, showEpisode:String, showAvaiL:String, dbAction:String) {
        
        //addTV
        //let newShow = Show()
        //newShow.setName(self.showName.text!)
        //newShow.setSeason(self.showSeason.text!)
        //newShow.setEpisode(self.showEpisode.text!)
        //newShow.setAvail(1)
        //self.showArray.append(newShow)
        
        self.data["action"] = "addTV"
        self.data["tv"] = showName
        self.data["season"] = showSeason
        self.data["episode"] = showEpisode
        self.data["avail"] = showAvaiL
        self.data["db"] = dbAction
        
        self.connection = Connection.upload
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: URL, view: self.view)

    }
 }

