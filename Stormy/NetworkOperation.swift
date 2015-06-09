//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Suthananth Arulanantham on 07.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation

class NetworkOperation{
    lazy var config : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session : NSURLSession = NSURLSession(configuration: self.config)
    
    let queryURL : NSURL
    
    typealias JSONDictionaryCompletion = ([String:AnyObject]?)->Void
    
    init(url:NSURL){
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion){
        let request = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse{
                // look for response information in http://httpstatus.es
                switch(httpResponse.statusCode){
                case 200:
                let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
                    
                completion(jsonDictionary)
                    
                default:
                    println("Get request not successfull. HTTP status code:")
                }
            }else{
                println("Error: Not a valid HTTP response")
            }
        })
        dataTask.resume()
    }
    
    
}
