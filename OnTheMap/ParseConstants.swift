//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

extension OnTheMapClient {

    struct ParseConstants {
        
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let BaseURL = "https://api.parse.com/1/"
    }
    
    struct ParseMethods {
    
        static let StudentLocation = "classes/StudentLocation"
    }
    
    struct ParseParameterKeys {
    
        static let AppIdParam = "X-Parse-Application-Id"
        static let ApiKeyParam = "X-Parse-REST-API-Key"
    }
    
    
    
    struct ParseJSONResponseKeys {
        
        static let Result = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
    }
}