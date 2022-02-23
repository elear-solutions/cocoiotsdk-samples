//
/**
 * @file      AttributeView.swift
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

protocol AttributeDelegate {
  func actionPower(_ sender: UIButton)
  func actionNotification(_ sender: UIButton)
}

final class AttributeView: NibLoadableView {

  @IBOutlet weak var AttributeName: UILabel!
  @IBOutlet weak var AttributeValue: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var actionNotification: UIButton!
  var delegate: AttributeDelegate?
  
  override func initialize() {
    super.initialize()
  }

  @IBAction func actionPower(_ sender: UIButton) {
    delegate?.actionPower(sender)
  }
  
  @IBAction func actionNotification(_ sender: UIButton) {
    delegate?.actionNotification(sender)
  }
}
