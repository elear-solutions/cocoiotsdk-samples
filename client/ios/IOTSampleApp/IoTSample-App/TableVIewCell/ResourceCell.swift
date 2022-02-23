/**
 * @file      ResourceCell.swift
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

protocol ResourceCellDelegate {
  func actionOnOff(_ sender: UIButton)
  func actionNotification(_ sender: UIButton)
}

class ResourceCell: UITableViewCell {
  
  @IBOutlet weak var attributeView: UIView!
  @IBOutlet weak var attributeName: UILabel!
  @IBOutlet weak var attributeValue: UILabel!
  @IBOutlet weak var onOffButton: UIButton!
  @IBOutlet weak var notificationButton: UIButton!
  @IBOutlet weak var resourceStackView: UIStackView!
  @IBOutlet weak var resourceName: UILabel!
  @IBOutlet weak var resourceNameView: UIView!
  var deleagte:ResourceCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.resourceStackView.layer.borderWidth = 1
    self.resourceStackView.layer.cornerRadius = 5
    self.resourceStackView.layer.borderColor = UIColor.white.cgColor
    self.resourceNameView.layer.borderWidth = 1
    self.resourceNameView.layer.cornerRadius = 5
    self.resourceNameView.layer.borderColor = UIColor.white.cgColor
    
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  @IBAction func actionOnOff(_ sender: UIButton) {
    deleagte?.actionOnOff(sender)
  }
  
  @IBAction func actionNotification(_ sender: UIButton) {
    deleagte?.actionNotification(sender)
  }
}
