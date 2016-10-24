//
//  posterDetailsCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/23/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class posterDetailsCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var businessPosterView: UIImageView!
    
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
