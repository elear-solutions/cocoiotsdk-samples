//
//  OAuthDelegateImplementation.swift
//  IoTSample-App
//
//  Created by Shrinivas on 13/12/21.
//

import Foundation
import IOTClientSDK
import os
import AppAuth

struct Token : Codable {
  let access_token : String
  let token_type : String
  let expires_at: Int
  let refresh_token: String
}

class OAuthDelegateImplementation: OAuthDelegate {
  
  static var shared = OAuthDelegateImplementation()
  var controller: UIViewController?
  private var authState: OIDAuthState?
  var configuration: OIDServiceConfiguration?
  let lock = NSLock()
  
  func RefreshTokenCB(status: StatusCode) {
    //TODO
  }
  
  func AccessTokenCallback(token: String?,
                           status: StatusCode,
                           context: UnsafeMutableRawPointer?)
  {
    Swift.print("Started")
    if status == .COCO_STD_STATUS_SUCCESS {
      COCOInitialization.getAllNetworks(context: nil)
    }
    Swift.print("Completed \(#function) \(#line)")
  }
  
  func OAuthCallback(authorizationEndpoint: String, tokenEndpoint: String) {
    Swift.print("Started \(#function) \(#line)")
    self.authenticateUser(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
    Swift.print("Completed \(#function) \(#line)")
  }
  
  func authenticateUser(authorizationEndpoint: String, tokenEndpoint: String) {
    Swift.print("Started \(#function) \(#line)")
    let _authorizationEndpoint = URL(string: authorizationEndpoint)!
    let _tokenEndpoint = URL(string: tokenEndpoint)!
    self.configuration = OIDServiceConfiguration(authorizationEndpoint: _authorizationEndpoint,
                                                 tokenEndpoint: _tokenEndpoint)
    self.sendAuthenticationRequest()
    Swift.print("Completed \(#function) \(#line)")
  }
  
  func sendAuthenticationRequest() {
    Swift.print("Started \(#function) \(#line)")
    
    guard let _controller = controller else {
      return
    }
    
    guard let _configuration = self.configuration else {
      return
    }
    
    let request = OIDAuthorizationRequest(configuration: _configuration,
                                          clientId: COCOInitialization.shared.clientID,
                                          clientSecret: nil,
                                          scopes: [OIDScopeOpenID, OIDScopeProfile],
                                          redirectURL: URL(string: COCOInitialization.shared.redirectURI)!,
                                          responseType: OIDResponseTypeCode,
                                          additionalParameters: nil)
    
    Swift.print("Initiating authorisations request with scope: \(request.scope ?? "nil")")
    
    
    
    DispatchQueue.main.async {
      //      var _ = CocoAppAuth(clientId: ApplicationConfig.shared.clientID,
      //                          redirectUri: ApplicationConfig.shared.redirectUri,
      //                          onSuccess: { (Token) in
      //                            Swift.print("Token Received \(String(describing: Token!))");
      //                            do {
      //                              try CocoClient.setTokens(response: Token!);
      //                              Swift.print("getAllNetworks Called")
      //                            } catch {
      //                              Swift.print("Error in setTokens")
      //                            }
      //
      //                          }) { (userInfo) in
      //        Swift.print("UserInfo:: \(String(describing: userInfo))");
      //      };
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request,
                                                                    presenting: _controller) { authState, error in
        if let authState = authState {
          print("Got authorisation tokens. Access token: " +
                  "\(authState.lastTokenResponse?.accessToken ?? "nil")")
          
          let _token = Token(access_token: authState.lastTokenResponse!.accessToken!,
                             token_type: authState.lastTokenResponse!.tokenType!,
                             expires_at: Int(authState.lastTokenResponse!.accessTokenExpirationDate!.timeIntervalSince1970), refresh_token: authState.lastTokenResponse!.refreshToken!)
          let jsonEncoder = JSONEncoder()
          do {
            let jsonData = try jsonEncoder.encode(_token)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String ::::: " + jsonString!)
            COCOInitialization.shared.setAccessToken(token: jsonString!)
          }
          catch {
          }
        } else {
          print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
          //self.setAuthState(nil)
        }
      }
      
    }
    print("Completed \(#function) \(#line)")
  }

}
