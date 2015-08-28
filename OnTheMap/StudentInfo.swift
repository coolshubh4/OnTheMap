//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 22/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

struct StudentInfo {
    
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectId: String? = nil
    var uniqueKey: Int? = nil
    var updatedAt: String? = nil
    
    init (dictionary: [String: AnyObject]) {
    
        createdAt = dictionary[OnTheMapClient.ParseJSONResponseKeys.CreatedAt] as? String
        firstName = dictionary[OnTheMapClient.ParseJSONResponseKeys.FirstName] as? String
        lastName = dictionary[OnTheMapClient.ParseJSONResponseKeys.LastName] as? String
        latitude = dictionary[OnTheMapClient.ParseJSONResponseKeys.Latitude] as? Double
        longitude = dictionary[OnTheMapClient.ParseJSONResponseKeys.Latitude] as? Double
        mapString = dictionary[OnTheMapClient.ParseJSONResponseKeys.MapString] as? String
        mediaURL = dictionary[OnTheMapClient.ParseJSONResponseKeys.MediaURL] as? String
        objectId = dictionary[OnTheMapClient.ParseJSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[OnTheMapClient.ParseJSONResponseKeys.UniqueKey] as? Int
        updatedAt = dictionary[OnTheMapClient.ParseJSONResponseKeys.UpdatedAt] as? String
    }
    
    static func studentInfoFromResults(results: [[String: AnyObject]]) -> [StudentInfo] {
    
        var student = [StudentInfo]()
        
        for result in results {
            student.append(StudentInfo(dictionary: result))
        }
        return student
    }

    static func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-08-22T22:27:14.456Z",
                "firstName" : "Shubham",
                "lastName" : "Tripathi",
                "latitude" : 18.9750,
                "longitude" : 72.8258,
                "mapString" : "Mumbai, MH, India",
                "mediaURL" : "https://www.linkedin.com/in/shubhamtripathi4",
                "objectId" : "04041990",
                "uniqueKey" : 04041990,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ],
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }
}