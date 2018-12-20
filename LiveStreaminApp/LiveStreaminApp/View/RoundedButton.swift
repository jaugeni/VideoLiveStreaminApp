//
//  RoundedButton.swift
//  LiveStreaminApp
//
//  Created by YAUHENI IVANIUK on 11/30/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 5
  }
}
