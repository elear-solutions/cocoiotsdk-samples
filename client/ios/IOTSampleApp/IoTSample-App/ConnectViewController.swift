/**
 * @file      ConnectViewController.swift
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

import UIKit
import AppAuth
import IOTClientSDK

var uiCallback: CocoCallbackDelegate?

class ConnectViewController: UIViewController {

  @IBOutlet weak var networkTableView: UITableView!
  

  override func viewWillAppear(_ animated: Bool) {
    // registerNib()
    COCOInit()
    COCOInitialization.shared.uiCallback = self
    OAuthDelegateImplementation.shared.controller = self
    COCOInitialization.shared.getAccessToken(context: nil)
    COCOInitialization.getAllNetworks(context: nil)
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    networkTableView.refreshControl = refreshControl
  }
  
  /// Initialisation of IOTClientSDK
  func COCOInit() {
    
//    /// Specify the client id you got from ( [coco portal](https://manage.getcoco.buzz))
//    let redirectURI: String = "coco5ef1d1d4c0b12ba45ad9://oauth/redirect"
//
//    /// Specify the client id you got from ( [coco portal](https://manage.getcoco.buzz))
//    let clientID: String = "5ef1d1d4c0b12ba45ad9"
//    let libraryDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
//
//    /// specify the app capability access list in json format like: "{\"appCapabilities\": [Specify the capability list]"
//    let appCapabilities = "{\"appCapabilities\": [" + String(describing: Capability.CapabilityId.COCO_STD_CAP_ON_OFF_CONTROL.rawValue) + String(describing: Capability.CapabilityId.COCO_STD_CAP_TEMPERATURE_MEASUREMENT.rawValue) + "]"
    
    COCOInitialization.shared.cocoInit()
//    do {
//      try CocoClient.setup(cwdPath: libraryDirectoryPath, /// Current working directory for app
//                           appScope: appCapabilities,
//                           clientId: clientID,
//                           downloadPath: libraryDirectoryPath, /// download path of cococlient-sdk
//                           oauthDelegate: OAuthDelegateImplementation.shared,
//                           cocoCallbackDelegate: CocoCallbackImplementation.shared,
//                           connectivityTimers: nil,
//                           creator: nil)
//    } catch {
//      fatalError(error.localizedDescription)
//    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.navigationBar.topItem?.title = "Connect to COCONet"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @objc func refresh(refreshControl: UIRefreshControl) {
    COCOInitialization.getAllNetworks(context: nil)
    refreshControl.endRefreshing()
  }
}

extension ConnectViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewController = StoryBoard.main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
      return
    }
    viewController.network = networkListData[indexPath.row]
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}

extension ConnectViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //TODO
    return networkListData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //TODO
    let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkCell", for: indexPath) as! NetworkCell
    cell.networkName.text = networkListData[indexPath.row].name ?? ""
    cell.networkView.layer.borderWidth = 1
    cell.networkView.layer.borderColor = UIColor.white.cgColor
    cell.networkView.layer.cornerRadius = 5
    return cell
  }
}

class NetworkCell: UITableViewCell {
  @IBOutlet weak var networkView: UIView!
  @IBOutlet weak var networkName: UILabel!
}

extension ConnectViewController: CocoCallbackDelegate {
  
  func NetworkListCallback(networkList: [Network], context: UnsafeMutableRawPointer?) {
    DispatchQueue.main.async {
      self.networkTableView.reloadData()
    }
  }
  
}
