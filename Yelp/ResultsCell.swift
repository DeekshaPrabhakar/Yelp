//
//  ResultsCell.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLbl: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var noOfReviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var businessObj: Business! {
        didSet {
            fillCell()
        }
    }
    
    func fillCell() {
        businessNameLbl.text = "\(businessObj.businessRowIndex!). " + businessObj.name!
        distanceLabel.text = businessObj.distance
        priceRangeLabel.text = "$$"
        
        if businessObj.imageURL != nil {
            
            businessImageView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.businessImageView.setImageWith(self.businessObj.imageURL!)
                self.businessImageView.alpha = 1
                }, completion: nil)
        }
       
        if businessObj.ratingImageURL != nil {
            
            ratingImageView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.ratingImageView.setImageWith(self.businessObj.ratingImageURL!)
                self.ratingImageView.alpha = 1
                }, completion: nil)
        }

        noOfReviewsLabel.text = "\(businessObj.reviewCount!) Reviews"
        
        addressLabel.text = businessObj.address
        categoriesLabel.text = businessObj.categories
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        businessImageView.layer.cornerRadius = 8.0
        businessImageView.clipsToBounds = true
        businessNameLbl.preferredMaxLayoutWidth = businessNameLbl.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessNameLbl.preferredMaxLayoutWidth = businessNameLbl.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
