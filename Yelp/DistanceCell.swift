//
//  DistanceCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/22/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

@objc protocol DistanceCellDelegate {
    @objc optional func distanceSwitchCell(distanceSwitchCell: DistanceCell, didChangeValue:Bool)
}

class DistanceCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var distanceLabelSwitchView: UIView!
    weak var distanceDelegate:DistanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        distanceLabelSwitchView.layer.cornerRadius = 8
        distanceLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        distanceLabelSwitchView.layer.borderWidth = 0.8
        
        distanceSwitch.addTarget(self, action: #selector(DistanceCell.distanceValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func distanceValueChanged() {
        distanceDelegate?.distanceSwitchCell?(distanceSwitchCell: self, didChangeValue: distanceSwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
