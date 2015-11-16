//
//  MOHTTPRequest.swift
//  SwiftHTTPManager
//
//  Created by Marcus Osobase on 2015-11-13.
//  Copyright © 2015 marcxs.com. All rights reserved.
//

import UIKit

class MOHTTPRequest: NSObject {

  enum MOHTTPRequestMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
  }
  
  var url: NSString!
  var method: MOHTTPRequestMethod
  var parameters: NSDictionary!
  var completion: String?
  var request: NSMutableURLRequest
  
  init(url: NSString!, method: MOHTTPRequestMethod, parameters: NSDictionary?,
    completion: String?) {
    self.url = url
    self.method = method
    self.parameters = parameters
    self.completion = completion
    self.request = NSMutableURLRequest(URL:NSURL(string: self.url as String)!)
    
    super.init()
  }
  
  func setUpParameters() {
    let boundary = "MOHTTPRequestBoundary"
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    var hasData: Bool!
    let postData = NSMutableData()
    
    
    hasData = false
    if (!hasData) {
      let dataString =
      [UInt8](parameterStringFromDictionarty(self.parameters)!.utf8)
      postData.appendBytes(dataString, length: dataString.count)
      request.setValue("application/x-www-form-urlencoded",
        forHTTPHeaderField: "Content-Type")
      request.HTTPBody = postData
      
    }
    else {
      self.parameters.enumerateKeysAndObjectsUsingBlock {
        (key, object, stop) -> Void in
        
        if (object is NSData && !(object is NSURL)) {
          postData.appendData("--\(boundary)\r\n"
            .dataUsingEncoding(NSUTF8StringEncoding)!)
          postData.appendData(
            "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
              .dataUsingEncoding(NSUTF8StringEncoding)!)
          postData.appendData(object.dataUsingEncoding(NSUTF8StringEncoding)!)
          postData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
      
        postData.appendData("--\(boundary)--\r\n"
          .dataUsingEncoding(NSUTF8StringEncoding)!)
        self.request.HTTPBody = postData
      }
    }
    
    let a = String(data: self.request.HTTPBody!, encoding: NSUTF8StringEncoding)
    print(a!)
  }
  
  func parameterStringFromDictionarty(dictionary: NSDictionary) -> String? {
    let parameters = NSMutableArray()
    
    for (key, value) in dictionary {
      if(dictionary[key as! NSCopying] is String) {
        let encodedValue = value
          .stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet(charactersInString:
              ":/=,!$&'()*+;[]@#?^%\"`<>{}\\|~ ").invertedSet)!
        parameters.addObject(
          "\(key)=\(encodedValue)")
      }
      else if (dictionary[key as! NSCopying] is NSNumber) {
        parameters.addObject("\(key)=\(value)")
      }
    }
    
    return parameters.componentsJoinedByString("&")
  }
  
  func signRequest(username username:String, password: String) {
    let authString = "\(username):\(password)"
    let authData = authString.dataUsingEncoding(NSASCIIStringEncoding)
    let encodedData = authData?
      .base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
    let authValue = "Basic \(encodedData)"
    request.setValue(authValue, forHTTPHeaderField: "Authorization")
  }
  
  func set(value value: String, forHTTPHeaderField field: String) {
    request.setValue(value, forHTTPHeaderField: field)
  }
  
  func performRequest() {
    
    setUpParameters()
    
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = self.method.rawValue
    
    
    let task = session.dataTaskWithRequest(request) { (data,
      response, error) -> Void in
      
      if (response != nil){
        print("\n \(response!)")
      }
      
      if (data != nil) {
        let a = String(data: data!, encoding: NSUTF8StringEncoding)
        print("\n \(a!)")
      }
      
      if (error != nil) {
        print("\n \(error!)")
      }

    }
    
    task.resume()
    
  }

}
