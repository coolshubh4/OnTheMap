//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaText: UITextView!
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var findOrSubmitButton: UIButton!
    
    var userLat: CLLocationDegrees? = nil
    var userLon: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
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
            
            println("Geolocation - \(locationText.text)")
            getLatLonForLocation(locationText.text)
            
        } else if action == "Submit" {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
            presentViewController(controller, animated: true, completion: nil)
        }
    }
//    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//        println("Inside mapView func")
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            //pinView!.canShowCallout = true
//            pinView!.pinColor = .Red
//            //pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//        
//        return pinView
//    }
    
    func getLatLonForLocation(userLocation: String!) {
        
        CLGeocoder().geocodeAddressString(userLocation) { placemarks, error in
            
            if error != nil {
                println("Error - \(error)")
                let alert = UIAlertController(title: "alert", message: "location not found", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                if placemarks == nil {
                    println("placemarks returned as nil")
                } else {
                    println("placemarks returned")
                    self.locationText.hidden = true
                    self.mapView.hidden = false
                    var placemark = placemarks[0] as! CLPlacemark
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = placemark.location.coordinate
                    let mapRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(CLLocationDegrees(0.1), CLLocationDegrees(0.1)))
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(mapRegion, animated: true)
                    self.findOrSubmitButton.setTitle("Submit", forState: .Normal)
                }
            }
        }
    }
}