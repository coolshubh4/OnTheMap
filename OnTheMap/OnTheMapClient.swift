//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 27/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import Foundation

class OnTheMapClient: NSObject {
    
    var session: NSURLSession
    
    // Student Info
    var student = [StudentInfo]()
    
    var accountID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var objectID: String? = nil
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    /* Helper: Given Dictionary, return a JSON object */
    func dictToJson(dict: [String: AnyObject]) -> NSData? {
        
        var jsonError: NSError? = nil
        
        let jsonDict = NSJSONSerialization.dataWithJSONObject(dict, options: nil, error: &jsonError)
        
        if let result = jsonDict {
            return result
        } else {
            println("Error while converting dictionary to JSON \(jsonError)")
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func sharedInstance() -> OnTheMapClient {
        
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        return Singleton.sharedInstance
    }
}