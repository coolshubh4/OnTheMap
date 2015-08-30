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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLat: CLLocationDegrees? = nil
    var userLon: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationText.delegate = self
        mediaText.delegate = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mediaText.text = "Where did you study today?"
        mapView.hidden = true
        locationText.hidden = false
        locationText.text = "Enter your location"
        activityIndicator.hidden = true
        findOrSubmitButton.setTitle("Find on the Map", forState: .Normal)
    }
    
    @IBAction func cancel(sender: AnyObject) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOrSubmitButton(sender: UIButton!){
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
            activityIndicator.hidden = false
        } else if action == "Submit" {
            postStudentData()
        }
    }
    
    func getLatLonForLocation(userLocation: String!) {
        
        CLGeocoder().geocodeAddressString(userLocation) { placemarks, error in
            
            if error != nil {
                self.activityIndicator.stopAnimating()
                let errMsg: String? = (error!.code == 8) ? "\(userLocation) cannot be located on the map. Please retry with a different location" : "No network connection available"
                self.displayAlertView(errMsg!)
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
    
    func mapViewWillStartRenderingMap(mapView: MKMapView!) {
        activityIndicator.startAnimating()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        activityIndicator.stopAnimating()
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
                dispatch_async(dispatch_get_main_queue()){
                    self.displayAlertView(errorString!)
                }
            }
        }
    }
    
    func displayAlertView(alertMessage: String!) {
        
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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