//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 22/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import MapKit
struct StudentInfo {
    
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: CLLocationDegrees? = nil
    var longitude: CLLocationDegrees? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectID: String? = nil
    var uniqueKey: String? = nil
    var updatedAt: String? = nil
    
    var coordinate: CLLocationCoordinate2D? = nil
    
    init (studentDict: [String: AnyObject]) {
    
        createdAt = studentDict[OnTheMapClient.ParseJSONResponseKeys.CreatedAt] as? String
        firstName = studentDict[OnTheMapClient.ParseJSONResponseKeys.FirstName] as? String
        lastName = studentDict[OnTheMapClient.ParseJSONResponseKeys.LastName] as? String
        mapString = studentDict[OnTheMapClient.ParseJSONResponseKeys.MapString] as? String
        mediaURL = studentDict[OnTheMapClient.ParseJSONResponseKeys.MediaURL] as? String
        objectID = studentDict[OnTheMapClient.ParseJSONResponseKeys.ObjectId] as? String
        uniqueKey = studentDict[OnTheMapClient.ParseJSONResponseKeys.UniqueKey] as? String
        updatedAt = studentDict[OnTheMapClient.ParseJSONResponseKeys.UpdatedAt] as? String
        
        
        latitude = CLLocationDegrees(studentDict[OnTheMapClient.ParseJSONResponseKeys.Latitude] as! Double)
        longitude = CLLocationDegrees(studentDict[OnTheMapClient.ParseJSONResponseKeys.Longitude] as! Double)
        
        coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
}