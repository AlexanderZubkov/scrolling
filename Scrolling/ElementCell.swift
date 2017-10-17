//
//  ElementCell.swift
//  Scrolling
//
//  Created by Alexander Zubkov on 16.10.17.
//  Copyright © 2017 Alexander Zubkov. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bedroomLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func load(_ element: Element) {
    if let string = element.title {
      self.titleLabel.text = string
    }
    if let value = element.bedrooms {
      let bed = value == 1 ? "bedroom" : "bedrooms"
      self.bedroomLabel.text = "\(value) \(bed)"
    }
    if let value = element.price {
      self.priceLabel.text = "\(value)"
    }
  }
}
