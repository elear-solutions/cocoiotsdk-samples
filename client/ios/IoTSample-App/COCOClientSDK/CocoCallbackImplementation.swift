/**
 * @file      CocoCallbackImplementation.swift
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

var networkListData = [Network]()

class CocoCallbackImplementation: CocoCallbackDelegate {
  
  static var shared = CocoCallbackImplementation()
  
  func NetworkListCallback(networkList: [Network], context: UnsafeMutableRawPointer?) {
    print(dump(networkList))
    networkListData = networkList
    COCOInitialization.shared.uiCallback?.NetworkListCallback(networkList: networkList, context: context)
  }
  
  func NetworkStateChanged(network: Network, state: NetworkDatum) {
    COCOInitialization.shared.uiCallback?.NetworkStateChanged(network: network, state: state)
  }
  
  func ConnectStatusCallback(network: Network?, coconetStatus: Network.State, context: UnsafeMutableRawPointer?) {
    
      COCOInitialization.shared.uiCallback?.ConnectStatusCallback(network: network, coconetStatus: coconetStatus, context: context)
  }
  
  func NetworkCommandStatusCallback(networkCMDStatus: NetworkCMDStatus?, context: UnsafeMutableRawPointer?, cocoNetContext: UnsafeMutableRawPointer?) {
    COCOInitialization.shared.uiCallback?.NetworkCommandStatusCallback(networkCMDStatus: networkCMDStatus, context: context, cocoNetContext: cocoNetContext)
  }
  
  func ResourceCallback(resource: Resource?, context: UnsafeMutableRawPointer?) {
    COCOInitialization.shared.uiCallback?.ResourceCallback(resource: resource, context: context)
  }
  
  func ResourceAttributeCallback(attribute: Attribute?, context: UnsafeMutableRawPointer?) {
    
    guard attribute?.parentCapability!.capabilityId == .COCO_STD_CAP_TEMPERATURE_MEASUREMENT else {
      return
    }
    
    guard CapabilityTemperatureSensing.AttributeId.COCO_STD_ATTR_CURRENT_TEMP_CELSIUS.rawValue == attribute!.attributeId else {
      return
    }
    
    COCOInitialization.shared.uiCallback?.ResourceAttributeCallback(attribute: attribute, context: context)
  }
  
  func ResourceCommandStatusCallback(commandStateCB: CommandStateCB?,
                                     context: UnsafeMutableRawPointer?,
                                     cocoNetContext: UnsafeMutableRawPointer?) {
    COCOInitialization.shared.uiCallback?.ResourceCommandStatusCallback(commandStateCB: commandStateCB, context: context, cocoNetContext: cocoNetContext)
  }
  
}
