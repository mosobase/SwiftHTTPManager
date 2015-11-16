//
//  MOHTTPClient.swift
//  SwiftHTTPManager
//
//  Created by Marcus Osobase on 2015-11-13.
//  Copyright © 2015 marcxs.com. All rights reserved.
//

import UIKit

class MOHTTPClient: NSObject {

  static let instance = MOHTTPClient()
  
  var username: String!
  var password: String!
  
  func authenticationCredentials(username username: String, password: String) {
    self.username = username
    self.password = password
  }
  
  func POST(url: NSString!, parameters: NSDictionary?, completion: String? )
    -> MOHTTPRequest {
    let request = MOHTTPRequest(url: url, method: .POST,
      parameters: parameters, completion: nil)
    if(self.username != nil && self.password != nil) {
        request.signRequest(username: self.username, password: self.password)
    }
    return request
  }
  
  func GET(url: NSString!, parameters: NSDictionary?, completion: String? )
    -> MOHTTPRequest {
    let request = MOHTTPRequest(url: url, method: .GET,
      parameters: parameters, completion: nil)
    if(self.username != nil && self.password != nil) {
      request.signRequest(username: self.username, password: self.password)
    }
    return request
  }
  
  func resetCredentials() {
    self.username = nil
    self.password = nil
  }
}