/**
 * @file      MainViewController.swift
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

import UIKit
import IOTClientSDK

class MainViewController: UIViewController {
  
  @IBOutlet weak var attributeTableView: UITableView!
  var network: Network?
  var resources = [Resource]()
  
  override func viewDidLoad() {
    COCOInitialization.shared.uiCallback = self
    attributeTableView.register(ResourceCell.self, forCellReuseIdentifier: "ResourceCell")
    self.registerNib()
    self.connectToNetwork()
    self.loadNewData()
  }
  
  func connectToNetwork() {
    do {
      _ = try network?.connect()
    } catch {
      //TODO
    }
  }
  
  func loadNewData() {
    resources.removeAll()
    for (_, zone) in network?.zoneMap ?? [:] {
      for resource in zone.resources {
        resources.append(resource)
      }
    }
  }
  
  func registerNib() {
    let cellName = String(describing: ResourceCell.self)
    let nib = UINib(nibName: cellName, bundle: nil)
    attributeTableView.register(nib, forCellReuseIdentifier: cellName)
  }
}

extension MainViewController: UITableViewDelegate {
  // TODO
}


extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resources.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
    cell.resourceName.text = resources[indexPath.row].name
    cell.deleagte = self
    cell.onOffButton.setTitle("", for: .normal)
    cell.onOffButton.setImage(UIImage(named: "power_on"), for: .normal)
    cell.onOffButton.tag = indexPath.row
    cell.notificationButton.setTitle("", for: .normal)
    cell.notificationButton.setImage(UIImage(named: "icr_notification-bell"), for: .normal)
    cell.notificationButton.tintColor = .white
    cell.onOffButton.tintColor = .white
    cell.notificationButton.isHidden = true
    
    cell.attributeName.text = "-"
    cell.attributeValue.text = "-"
    cell.onOffButton.isHidden = true
    
    for (id, capability) in resources[indexPath.row].capabilityMap {
      if id == .COCO_STD_CAP_TEMPERATURE_MEASUREMENT {
        cell.attributeName.text = "Temperature: "
        cell.attributeValue.text = String(describing: capability.attributeMap[CapabilityTemperatureSensing.AttributeId.COCO_STD_ATTR_CURRENT_TEMP_CELSIUS.rawValue]?.currentValue as? Double ?? 0) + " °C"
        cell.attributeValue.textColor = .green
        cell.onOffButton.isHidden = true
        break
      } else if id == .COCO_STD_CAP_ON_OFF_CONTROL {
        cell.attributeName.text = "Power Supply: "
        let state = capability.attributeMap[CapabilityTemperatureSensing.AttributeId.COCO_STD_ATTR_CURRENT_TEMP_CELSIUS.rawValue]?.currentValue as? Bool ?? false
        cell.attributeValue.text = state ? "On" : "Off"
        cell.onOffButton.tintColor = state ? .green : .white
        cell.attributeValue.textColor = state ? .green : .white
        cell.onOffButton.isSelected = state ? true : false
        cell.onOffButton.isHidden = false
        break
      }
    }
    return cell
  }
  
}

extension MainViewController: CocoCallbackDelegate {
  
  func ConnectStatusCallback(network: Network?, coconetStatus: Network.State, context: UnsafeMutableRawPointer?) {
    DispatchQueue.main.async {
      self.loadNewData()
      self.attributeTableView.reloadData()
    }
  }
  
  func ResourceCallback(resource: Resource?, context: UnsafeMutableRawPointer?) {
    DispatchQueue.main.async {
      self.loadNewData()
      self.attributeTableView.reloadData()
    }
  }
  
  func ResourceAttributeCallback(attribute: Attribute?, context: UnsafeMutableRawPointer?) {
    DispatchQueue.main.async {
      self.loadNewData()
      self.attributeTableView.reloadData()
    }
  }
}

extension MainViewController: ResourceCellDelegate {
  func actionOnOff(_ sender: UIButton) {
      if let capbility = resources[sender.tag].capabilityMap[.COCO_STD_CAP_ON_OFF_CONTROL] {
        let command: Resource.ResourceCommand?
        if !sender.isSelected {
          command = CapabilityOnOff.OnCommand()
        } else {
          command = CapabilityOnOff.OffCommand()
        }
        sender.isSelected = !sender.isSelected
        do {
          let result = try capbility.sendResourceCommand(command: command!, handler: { status in
            //TODO
          }, commandContext: nil)
        } catch {
          print("Error On/Off Command \(error.localizedDescription)")
        }
      }
  }
  
  func actionNotification(_ sender: UIButton) {
    //TODO
  }
  
  
}
