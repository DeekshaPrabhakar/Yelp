//
//  SeeAllCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/23/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class SeeAllCell: UITableViewCell {

    @IBOutlet weak var seeAllLabelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seeAllLabelView.layer.cornerRadius = 10
        seeAllLabelView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        seeAllLabelView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
