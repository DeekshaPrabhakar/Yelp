//
//  SortByCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/23/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

@objc protocol SortByCellDelegate {
    @objc optional func sortBySwitchCell(sortBySwitchCell: SortByCell, didChangeValue:Bool)
}

class SortByCell: UITableViewCell {
    
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortBySwitch: UISwitch!
    @IBOutlet weak var sortByLabelSwitchView: UIView!
    @IBOutlet weak var sortByButton: UIButton!
    
    weak var sortByDelegate:SortByCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sortByLabelSwitchView.layer.cornerRadius = 8
        sortByLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        sortByLabelSwitchView.layer.borderWidth = 0.8
        
        let notDoneImage = UIImage(named: "oval")
        sortByButton.setImage(notDoneImage, for: UIControlState.normal)
        sortByButton.addTarget(self, action: #selector(SortByCell.sortByValueChanged), for: UIControlEvents.touchUpInside)
        
        //sortBySwitch.addTarget(self, action: #selector(SortByCell.sortByValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func sortByValueChanged() {
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        var isSelected = false
        if(sortByButton.currentImage == notDoneImage){
            sortByButton.setImage(doneImage, for: UIControlState.normal)
            sortByButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)//blue
            isSelected = true
        }
        else {
            sortByButton.setImage(notDoneImage, for: UIControlState.normal)
            sortByButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)//gray
            isSelected = false
        }

        //sortByDelegate?.sortBySwitchCell?(sortBySwitchCell: self, didChangeValue: sortBySwitch.isOn)
        sortByDelegate?.sortBySwitchCell?(sortBySwitchCell: self, didChangeValue: isSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
