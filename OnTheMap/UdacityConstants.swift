//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

extension OnTheMapClient {

    struct UdacityConstants {
        
        static let BaseURL = "https://www.udacity.com/api/"
    }
    
    struct UdacityMethods {
        
        static let Session = "session"
        static let User = "users/"
    }
    
    struct UdacityJSONResponseKeys {
        
        static let AccountKey = "key"
        static let Account = "account/"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}