/**
 * @file      ApplicationConfiguration.swift
 * @brief
 * @details
 * @see
 * @author    Shrinivas Gutte
 * @copyright Copyright (c) 2020 Elear Solutions Tech Private Limited.
 *            All rights reserved.
 * @license   To any person (the "Recipient") obtaining a copy of this software
 *            and associated documentation files (the "Software"):
 *            All information contained in or disclosed by this software is
 *            confidential and proprietary information of Elear Solutions Tech
 *            Private Limited and all rights therein are expressly reserved.
 *            By accepting this material the recipient agrees that this material
 *            and the information contained therein is held in confidence and
 *            in trust and will NOT be used, copied, modified, merged,
 *            published, distributed, sublicensed, reproduced in whole or
 *            in part, nor its contents revealed in any manner to others
 *            without the express written permission of Elear Solutions Tech
 *            Private Limited.
 */

import AppAuth

class ApplicationConfig {
  
  static var shared = ApplicationConfig()
  let authorizationEndpoint: String
  let tokenEndpoint: String
  var clientID: String = "59b8392bb7ba31d0ca7d"
  var redirectUri: String = "coco59b8392bb7ba31d0ca7d://oauth/redirect"
  var postLogoutRedirectUri: String = "coco59b8392bb7ba31d0ca7d://oauth/redirect"
  let scope: String
  
  init() {
    self.authorizationEndpoint = ""
    self.tokenEndpoint = ""
    self.clientID = ""
    self.scope = ""
  }
  
  func getRedirectURI() -> URL {
    guard let redirectURIURL = URL(string: redirectUri) else {
      fatalError( "Invalid Configuration Error: The Authorization Endpoint URL is not correct")
    }
    return redirectURIURL
  }
  
  func getConfiguration() -> OIDServiceConfiguration {
    
    guard let _authorizationEndpoint = URL(string: authorizationEndpoint) else {
      fatalError( "Invalid Configuration Error: The Authorization Endpoint URL is not correct")
    }
    
    guard let tokenEndpoint = URL(string: self.tokenEndpoint) else {
      fatalError( "Invalid Configuration Error: The token Endpoint URL is not correct")
    }
    
    return OIDServiceConfiguration(authorizationEndpoint: _authorizationEndpoint,
                                                tokenEndpoint: tokenEndpoint)
  }
  
}
