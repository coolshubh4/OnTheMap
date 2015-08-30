//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Shubham Tripathi on 23/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import Foundation

extension OnTheMapClient {

    func parseGetStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let urlString = ParseConstants.BaseURL + ParseMethods.StudentLocation + "?order=-updatedAt"
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseConstants.AppId, forHTTPHeaderField: ParseParameterKeys.AppIdParam)
        request.addValue(ParseConstants.ApiKey, forHTTPHeaderField: ParseParameterKeys.ApiKeyParam)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(success: false, errorString: "No network connection available")
            } else {
                OnTheMapClient.parseJSONWithCompletionHandler(data) { result, error in
                    if error != nil {
                        completionHandler(success: false, errorString: "\(error)")
                    } else {
                        if let dataResult = result as? [String: AnyObject] {
                            if let dataArray = dataResult[ParseJSONResponseKeys.Result] as? [[String: AnyObject]] {
                                OnTheMapClient.sharedInstance().studentData.removeAll(keepCapacity: true)
                                for element in dataArray {
                                    let student = StudentInfo(studentDict: element)
                                    OnTheMapClient.sharedInstance().studentData.append(student)
                                }
                                completionHandler(success: true, errorString: nil)
                            } else {
                                completionHandler(success: false, errorString: "Could not parse student data")
                            }
                        } else {
                            completionHandler(success: false, errorString: "\(result)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func parsePostStudentLocation(jsonBody: [String: AnyObject], completionHandler: (success: Bool, objectID: String?, errorString: String?) -> Void) {
        
        let urlString = ParseConstants.BaseURL + ParseMethods.StudentLocation
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseConstants.AppId, forHTTPHeaderField: ParseParameterKeys.AppIdParam)
        request.addValue(ParseConstants.ApiKey, forHTTPHeaderField: ParseParameterKeys.ApiKeyParam)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = dictToJson(jsonBody)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(success: false, objectID: nil, errorString: "No network connection available")
            } else {
                OnTheMapClient.parseJSONWithCompletionHandler(data) { result, error in
                    if let dataResult = result as? [String: AnyObject] {
                        if let objectID = dataResult[ParseJSONResponseKeys.ObjectId] as? String {
                            completionHandler(success: true, objectID: objectID, errorString: nil)
                        } else {
                            completionHandler(success: false, objectID: nil, errorString: "Error while posting pin")
                        }
                    } else {
                        completionHandler(success: false, objectID: nil, errorString: "Not able to parse")
                    }
                }
            }
        }
        task.resume()
    }
}