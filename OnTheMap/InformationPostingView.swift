//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingView: UIViewController, MKMapViewDelegate, UITextViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaText: UITextView!
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var findOrSubmitButton: UIButton!
    
    var userLat: CLLocationDegrees? = nil
    var userLon: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationText.delegate = self
        mediaText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mediaText.text = "Where did you study today?"
        mapView.hidden = true
        locationText.hidden = false
        locationText.text = "Enter your location"
        findOrSubmitButton.setTitle("Find on the Map", forState: .Normal)
    }
    
    @IBAction func cancel(sender: AnyObject) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOrSubmitButton(sender: UIButton!){
        println("\(sender.titleLabel?.text)")
        if sender.titleLabel?.text == "Find on the Map" {
            findOrSubmit(sender.titleLabel?.text)
        }   else if sender.titleLabel?.text == "Submit" {
            findOrSubmit(sender.titleLabel?.text)
        }
    }
    
    func findOrSubmit(action: String!) {
        
        if action == "Find on the Map" {
            mediaText.text = "Enter URL to share"
            getLatLonForLocation(locationText.text)
        } else if action == "Submit" {
            postStudentData()
        }
    }
    
    func getLatLonForLocation(userLocation: String!) {
        
        CLGeocoder().geocodeAddressString(userLocation) { placemarks, error in
            
            if error != nil {
                println("Error - \(error)")
                let alert = UIAlertController(title: "alert", message: "\(self.locationText.text!) not found", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                if placemarks == nil {
                    println("placemarks returned as nil")
                } else {
                    self.locationText.hidden = true
                    self.mapView.hidden = false
                    var placemark = placemarks[0] as! CLPlacemark
                    var annotation = MKPointAnnotation()
                    self.userLat = placemark.location.coordinate.latitude
                    self.userLon = placemark.location.coordinate.longitude
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.userLat!, longitude: self.userLon!)
                    let mapRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(CLLocationDegrees(0.1), CLLocationDegrees(0.1)))
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(mapRegion, animated: true)
                    self.findOrSubmitButton.setTitle("Submit", forState: .Normal)
                }
            }
        }
    }
    
    func postStudentData() {
        let jsonBody: [String: AnyObject] = [
            OnTheMapClient.ParseJSONResponseKeys.UniqueKey: OnTheMapClient.sharedInstance().accountID!,
            OnTheMapClient.ParseJSONResponseKeys.FirstName: OnTheMapClient.sharedInstance().firstName!,
            OnTheMapClient.ParseJSONResponseKeys.LastName: OnTheMapClient.sharedInstance().lastName!,
            OnTheMapClient.ParseJSONResponseKeys.Latitude: self.userLat!,
            OnTheMapClient.ParseJSONResponseKeys.Longitude: self.userLon!,
            OnTheMapClient.ParseJSONResponseKeys.MapString: locationText.text!,
            OnTheMapClient.ParseJSONResponseKeys.MediaURL: mediaText.text!
            ]
        
        OnTheMapClient.sharedInstance().postDataToParse(jsonBody) { success, errorString in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                println("\(errorString)")
            }
        }
    }
}

extension InformationPostingView {
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    // To return from textView
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}