//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 22/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annnotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add NavigationItems
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getMapData")
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "pinStudent")
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        mapView.delegate = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getMapData()
    }
    
    func getMapData() {
        OnTheMapClient.sharedInstance().parseGetStudentLocations() { success, errorString in
            if success {
                self.populateMapView()
            } else {
                println("Error - \(errorString!)")
            }
        }
    }
    
    func populateMapView() {
        
        for student in OnTheMapClient.sharedInstance().studentData {

            var annotation = MKPointAnnotation()
            annotation.coordinate = student.coordinate!
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = "\(student.mediaURL!)"
            
            annnotations.append(annotation)
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(self.annnotations)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    func mapViewWillStartRenderingMap(mapView: MKMapView!) {
        activityIndicator.startAnimating()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        activityIndicator.stopAnimating()
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