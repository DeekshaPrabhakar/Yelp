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
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var distanceLabelSwitchView: UIView!
    weak var distanceDelegate:DistanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        distanceLabelSwitchView.layer.cornerRadius = 8
        distanceLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        distanceLabelSwitchView.layer.borderWidth = 0.8
        
        let notDoneImage = UIImage(named: "oval")
        distanceButton.setImage(notDoneImage, for: UIControlState.normal)
        distanceButton.addTarget(self, action: #selector(DistanceCell.distanceValueChanged), for: UIControlEvents.touchUpInside)
        
        //distanceSwitch.addTarget(self, action: #selector(DistanceCell.distanceValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func distanceValueChanged() {
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        var isSelected = false
        if(distanceButton.currentImage == notDoneImage){
            distanceButton.setImage(doneImage, for: UIControlState.normal)
            distanceButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)//blue
            isSelected = true
        }
        else {
            distanceButton.setImage(notDoneImage, for: UIControlState.normal)
            distanceButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)//gray
            isSelected = false
        }
        //distanceDelegate?.distanceSwitchCell?(distanceSwitchCell: self, didChangeValue: distanceSwitch.isOn)
        distanceDelegate?.distanceSwitchCell?(distanceSwitchCell: self, didChangeValue: isSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
