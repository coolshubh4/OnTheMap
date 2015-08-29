//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var locations = [[String: AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add NavigationItems
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: nil)
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "pinStudent")
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        //self.locations = StudentInfo.hardCodedLocationData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapClient.sharedInstance().studentData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentPin") as! OnTheMapTableViewCell
        let student = OnTheMapClient.sharedInstance().studentData[indexPath.row]

        cell.studentName?.text = "\(student.firstName!) \(student.lastName!)"
        cell.studentLocation?.text = "\(student.mapString!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = OnTheMapClient.sharedInstance().studentData[indexPath.row]
        
        if let url = NSURL(string: student.mediaURL!) {
            let app = UIApplication.sharedApplication()
            app.openURL(url)
        }
    }
    
    func pinStudent() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout() {
        OnTheMapClient.sharedInstance().udacityDeleteSession()
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
}