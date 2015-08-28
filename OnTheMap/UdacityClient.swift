//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import Foundation

extension OnTheMapClient {
    
    func udacitySessionPost(jsonBody: [String: AnyObject], completionHandler: (success: Bool, accountID: String?, errorString: String?) -> Void) {
        
        let urlString = UdacityConstants.BaseURL + UdacityMethods.Session
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = dictToJson(jsonBody)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(success: false, accountID: nil, errorString: "\(error)")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                OnTheMapClient.parseJSONWithCompletionHandler(newData) { result, error in
                    if let dataResult = result as? NSDictionary {
                        if let account: AnyObject = dataResult.objectForKey(UdacityJSONResponseKeys.Account) {
                            if let accountID = account[UdacityJSONResponseKeys.AccountKey] as? String {
                                completionHandler(success: true, accountID: accountID, errorString: nil)
                            } else {
                                completionHandler(success: false, accountID: nil, errorString: "Login failed, invalid credentials - \(error)")
                            }
                        } else {
                            completionHandler(success: false, accountID: nil, errorString: "Login failed - \(error)")
                        }
                    } else {
                        completionHandler(success: false, accountID: nil, errorString: "Login failed - \(error)")
                    }
                }
            }
        }
        task.resume()
    }
}