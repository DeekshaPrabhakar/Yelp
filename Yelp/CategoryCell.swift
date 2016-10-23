//
//  CategoryCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/22/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

@objc protocol CategoryCellDelegate {
    @objc optional func categorySwitchCell(categorySwitchCell: CategoryCell, didChangeValue:Bool)
}

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var categoryLabelSwitchView: UIView!
    
    weak var delegate:CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryLabelSwitchView.layer.cornerRadius = 10
        categoryLabelSwitchView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        categoryLabelSwitchView.layer.borderWidth = 1
        
        categorySwitch.addTarget(self, action: #selector(CategoryCell.categoryValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func categoryValueChanged() {
        delegate?.categorySwitchCell?(categorySwitchCell: self, didChangeValue: categorySwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
