//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import Foundation

extension OnTheMapClient {
    
    func udacityPostSession(jsonBody: [String: AnyObject], completionHandler: (success: Bool, accountID: String?, errorString: String?) -> Void) {
        
        println("Inside udacityPostSession")
        let urlString = UdacityConstants.BaseURL + UdacityMethods.Session
        println("Inside udacityPostSession - url \(urlString)")
        let url = NSURL(string: urlString)!
        var jsonifyError: NSError? = nil
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = dictToJson(jsonBody)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            println("Inside udacityPostSession - task")
            if downloadError != nil {
                completionHandler(success: false, accountID: nil, errorString: "No network connection \(downloadError)")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                OnTheMapClient.parseJSONWithCompletionHandler(newData) { result, error in
                    
                    if let dataResult: NSDictionary = result as? NSDictionary {
                        println("Inside udacityPostSession - \(dataResult)")
                        if let account: AnyObject = dataResult.objectForKey(UdacityJSONResponseKeys.Account) {
                            println("Inside udacityPostSession - \(account)")
                            if let accountID = account[UdacityJSONResponseKeys.AccountKey] as? String {
                                println("Inside udacityPostSession - \(accountID)")
                                completionHandler(success: true, accountID: accountID, errorString: nil)
                            } else {
                                completionHandler(success: false, accountID: nil, errorString: "1. Cannot retrieve accountID - \(error)")
                            }
                        } else {
                            completionHandler(success: false, accountID: nil, errorString: "2. Login failed - \(error)")
                        }
                    } else {
                        completionHandler(success: false, accountID: nil, errorString: "3. Login failed - \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func udacityGetUserData(accountID: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        println("inside udacityGetUserData")
        let urlString = UdacityConstants.BaseURL + UdacityMethods.User + "\(accountID!)"
        println("udacityGetUserData url - \(urlString)")
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            println("inside udacityGetUserData - task")
            if downloadError != nil {
                completionHandler(success: false, errorString: "\(downloadError)")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length))
                OnTheMapClient.parseJSONWithCompletionHandler(newData) { result, error in
                    if let dataResult = result as? NSDictionary {
                        if let userData = dataResult.objectForKey(UdacityJSONResponseKeys.User) as? [String: AnyObject] {
                            self.firstName = userData[UdacityJSONResponseKeys.FirstName] as? String
                            self.lastName = userData[UdacityJSONResponseKeys.LastName] as? String
                            
                            println("firstName - \(self.firstName)")
                            println("secondName - \(self.lastName)")
                            completionHandler(success: true, errorString: nil)
                        } else {
                            completionHandler(success: false, errorString: "Unable to retrieve user data - \(error)")
                        }
                    } else {
                        completionHandler(success: false, errorString: "Unable to retrieve user data - \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func udacityDeleteSession() {
        let urlString = UdacityConstants.BaseURL + UdacityMethods.Session
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}