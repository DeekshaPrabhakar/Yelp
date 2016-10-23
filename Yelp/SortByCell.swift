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
    
    weak var sortByDelegate:SortByCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sortByLabelSwitchView.layer.cornerRadius = 8
        sortByLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        sortByLabelSwitchView.layer.borderWidth = 0.8
        
        sortBySwitch.addTarget(self, action: #selector(SortByCell.sortByValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func sortByValueChanged() {
        sortByDelegate?.sortBySwitchCell?(sortBySwitchCell: self, didChangeValue: sortBySwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
