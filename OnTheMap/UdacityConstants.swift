//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

extension UdacityClient {

    struct constants {
        
        static let BaseURL = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        
        static let Session = "session"
        static let User = "users/"
    }
    
    struct JSONResponseKeys {
        
        static let SessionId = "id"
        static let UserId = "key"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}