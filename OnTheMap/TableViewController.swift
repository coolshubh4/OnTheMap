//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locations = [[String: AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add NavigationItems
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: nil)
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "pinStudent")
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        self.locations = StudentInfo.hardCodedLocationData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentPin") as! OnTheMapTableViewCell
        let location = locations[indexPath.row]
        
        let firstName = location["firstName"] as? String
        let lastName = location["lastName"] as? String
        cell.studentName.text = firstName! + " " + lastName!
        cell.studentLocation.text = location["mapString"] as? String
        return cell
    }
    
    func pinStudent() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        presentViewController(controller, animated: true, completion: nil)
    }
}