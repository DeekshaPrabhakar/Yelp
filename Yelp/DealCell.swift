//
//  DealCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/22/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
    @objc optional func dealSwitchCell(dealSwitchCell: DealCell, didChangeValue:Bool)
}

class DealCell: UITableViewCell {

    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var dealSwitch: UISwitch!
    @IBOutlet weak var dealLabelSwitchView: UIView!
    
    weak var dealDelegate:DealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dealLabelSwitchView.layer.cornerRadius = 10
        dealLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        dealLabelSwitchView.layer.borderWidth = 1
        
        dealSwitch.addTarget(self, action: #selector(DealCell.dealValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func dealValueChanged() {
        dealDelegate?.dealSwitchCell?(dealSwitchCell: self, didChangeValue: dealSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
