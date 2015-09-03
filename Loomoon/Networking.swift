//
//  Networking.swift
//  Loomoon
//
//  Created by Yura Vorontsov on 02.09.15.
//  Copyright (c) 2015 Yura Vorontsov. All rights reserved.
//

import Foundation

protocol LoginDelegate: class
{
    func loginSuccess()
    func someErrorInLogin()
    func invalidLoginOrPassword()
}
protocol DataReciever: class
{
    func dataForCurrentUser(data: NSDictionary)
    func someNetworkError()
}

class Networking
{
    let hostUrl = "http://testme.dev.amict.ru/datapoint.php"
    weak var delegate: LoginDelegate!
    weak var dataReciever: DataReciever?
    func login(login str: String, password pwd: String)
    {
        var request = NSMutableURLRequest(URL: NSURL(string: hostUrl)!)
        request.addValue("SimpleJson", forHTTPHeaderField: "Content-Type")
        request.addValue("testme.dev.amict.ru", forHTTPHeaderField: "Host")
        request.HTTPMethod = "POST"
        let bodyJsonObj: [String: AnyObject] =
        [
            "Function": "Login",
            "RequestType": "SimpleJson",
            "ResponseType": "SimpleJson",
            "Data":
            [
                "login": str,
                "password": pwd
            ]
        ]
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(bodyJsonObj, options: NSJSONWritingOptions.allZeros, error: &err)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as? NSDictionary
            {
                if let jsonData = result["Data"] as? String, jsonStatus = result["Status"] as? String
                {
                    if jsonStatus == "ok"
                    {
                        if jsonData != "InvalidLoginOrPassword" && jsonData != "AccessDenied"
                        {
                            dispatch_async(dispatch_get_main_queue()){
                                self.delegate.loginSuccess()}
                            return
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.delegate.invalidLoginOrPassword()}
                        return
                    }
                }
            }
            println(err)
            dispatch_async(dispatch_get_main_queue()){
                self.delegate.someErrorInLogin()}
        }).resume()
    }
    
    
    func logout()
    {
        var request = NSMutableURLRequest(URL: NSURL(string: hostUrl)!)
        request.addValue("SimpleJson", forHTTPHeaderField: "Content-Type")
        request.addValue("testme.dev.amict.ru", forHTTPHeaderField: "Host")
        request.HTTPMethod = "POST"
        let bodyJsonObj: [String: AnyObject] =
        [
            "Function": "Logout",
            "RequestType": "SimpleJson",
            "ResponseType": "SimpleJson",
            "Data": ""
        ]
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(bodyJsonObj, options: NSJSONWritingOptions.allZeros, error: &err)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: nil).resume()
    }
    
    
    func userData()
    {
        var request = NSMutableURLRequest(URL: NSURL(string: hostUrl)!)
        request.addValue("SimpleJson", forHTTPHeaderField: "Content-Type")
        request.addValue("testme.dev.amict.ru", forHTTPHeaderField: "Host")
        request.HTTPMethod = "POST"
        let bodyJsonObj: [String: AnyObject] =
        [
            "Function": "UserInfo",
            "RequestType": "SimpleJson",
            "ResponseType": "SimpleJson",
            "Data": ""
        ]
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(bodyJsonObj, options: NSJSONWritingOptions.allZeros, error: &err)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as? NSDictionary
            {
                if let status = result["Status"] as? String, userInfo = result["Data"] as? NSDictionary
                {
                    if status == "ok"
                    {
                        dispatch_async(dispatch_get_main_queue()){
                            self.dataReciever?.dataForCurrentUser(userInfo)}
                        return
                    }
                }
            }
            println(err)
            dispatch_async(dispatch_get_main_queue()){
                self.dataReciever?.someNetworkError()}
        }).resume()
    }
}