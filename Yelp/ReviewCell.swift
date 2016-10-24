//
//  ReviewCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/23/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewLabelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewLabelView.layer.cornerRadius = 10
        reviewLabelView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        reviewLabelView.layer.borderWidth = 1
    }
    
    
    @IBAction func onWriteAReview(_ sender: AnyObject) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
