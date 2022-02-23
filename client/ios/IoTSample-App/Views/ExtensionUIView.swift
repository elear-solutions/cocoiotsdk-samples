/**
 * @file      ExtensionUIView.swift
 * @brief
 * @details
 * @see
 * @author    Shrinivas Gutte, shrinivasgutte@elear.solutions
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

extension UIView {
  // MARK: - Nib

  @discardableResult
  func addSelfNibUsingConstraints(nibName: String) -> UIView? {
    guard let nibView = loadSelfNib(nibName: nibName) else {
      assert(true, "---- UIView Extension Nib file not found ----")
      return nil
    }
    self.addSubviewUsingConstraints(view: nibView)
    return nibView
  }

  @discardableResult
  func addSelfNibUsingConstraints() -> UIView? {
    guard let nibView = loadSelfNib() else {
      assert(true, "---- UIView Extension Nib file not found ----")
      return nil
    }
    self.addSubviewUsingConstraints(view: nibView)
    return nibView
  }
  
  func loadSelfNib(nibName: String) -> UIView? {
    if let nibFiles = Bundle.main.loadNibNamed(nibName, owner: self, options: nil), nibFiles.count > 0 {
      return nibFiles.first as? UIView
    }
    return nil
  }
  
  func loadSelfNib() -> UIView? {
    let nibName = String(describing: type(of: self))
    if let nibFiles = Bundle.main.loadNibNamed(nibName, owner: self, options: nil),
       nibFiles.count > 0
    {
      return nibFiles.first as? UIView
    }
    return nil
  }
  
  /// Add subview
  func addSubviewUsingConstraints(view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)

    let left = NSLayoutConstraint(item: view,
                                  attribute: .left,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .left,
                                  multiplier: 1,
                                  constant: 0)
    let top = NSLayoutConstraint(item: view,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .top,
                                 multiplier: 1,
                                 constant: 0)
    let right = NSLayoutConstraint(item: self,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: 0)
    let bottom = NSLayoutConstraint(item: self,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .bottom,
                                    multiplier: 1,
                                    constant: 0)
    addConstraints([left, top, right, bottom])
  }
}
