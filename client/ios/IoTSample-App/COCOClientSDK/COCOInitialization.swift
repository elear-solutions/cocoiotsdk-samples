/**
 * @file      COCOInitialization.swift
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

import IOTClientSDK
import os

struct savedKeys {
  static var shared = savedKeys()
  var accessToken = "AccessToken"
}

class COCOInitialization {
  static let shared = COCOInitialization()
  let redirectURI: String = "coco59b8392bb7ba31d0ca7d://oauth/redirect"
  let clientID: String = "59b8392bb7ba31d0ca7d"
  let libraryDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
  var uiCallback: CocoCallbackDelegate?
  
  func cocoInit() {
    do {
      try IOTClient.setup(cwdPath: self.getCwdPath(), /// Current working directory for app
                           appScope: self.getAppAccesslist(), /// specify the app capability access list in json format like: "{\"appCapabilities\": [Specify the capability list]"
                           clientId: self.getClientId(), /// Specify the client id
                           downloadPath: self.getDownloadPath(),
                           oauthDelegate: OAuthDelegateImplementation.shared,
                           cocoCallbackDelegate: CocoCallbackImplementation.shared,
                           connectivityTimers: nil,
                           creator: nil)
    } catch {
      //TODO
    }
  }

  func getRedirectURI() -> String {
    return redirectURI
  }

  func getCwdPath() -> String {
    return libraryDirectoryPath
  }

  func getDownloadPath() -> String {
    return libraryDirectoryPath
  }

  func getClientId() -> String {
    return clientID
  }

  func getAppAccesslist() -> String {
    let CapabilityIds = Capability.CapabilityId.allCases
    var accessList = "{\"appCapabilities\": ["
    for capability in CapabilityIds {
      if capability == .COCO_STD_CAP_MIN || capability == .COCO_STD_CAP_MAX || capability == .COCO_STD_CAP_UBOUND {
        continue
      }

      accessList = accessList + String(describing: capability.rawValue)

      if capability.rawValue != (CapabilityIds.count - 4) {
        accessList = accessList + ","
      }
    }
    accessList = accessList + "]}"
    return accessList
  }

  public func getAccessToken(context: UnsafeMutableRawPointer?) {
    do {
      try IOTClient.getAccessToken(handler: { token, status in
        print("token :::: \(String(describing: token))")
        print("status :::: \(String(describing: status))")
        if status == .COCO_STD_STATUS_SUCCESS {
          COCOInitialization.getAllNetworks(context: nil)
        }
      })
    } catch {
      print("getAccessToken error: \(error.localizedDescription)")
    }
  }
  
  public func setAccessToken(token: String) {
    UserDefaults.standard.setValue(token, forKey: savedKeys.shared.accessToken)
    do {
      try IOTClient.setTokens(response: token)
    } catch {
      print("Authorization error: \(error.localizedDescription)")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
      self.getAccessToken(context: nil)
    })
  }

  public static func getAllNetworks(context: UnsafeMutableRawPointer?) {
    do {
      try IOTClient.shared.getAllCoconet(requestContext: nil)
      try IOTClient.shared.getSavedCoconets()
    } catch {
      //TODD
    }
  }

  public static func getSavedNetworks() -> [Network]? {
    do {
      return try IOTClient.shared.getSavedCoconets()
    } catch {
      //TODO
    }
    return nil
  }

  public static func connectToCoconet(network: Network?) {
    guard let network = network else {
      return
    }

    do {
      _ = try network.connect()
    } catch {
      //TODO
    }
  }
}
