//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var busObj:Business!
    let posterDtCellIdentifier = "posterDetailsCell"
    let ReviewCellIdentifier = "ReviewCell"
    let photoCkInBkMrkCellIdentifier = "photoCkInBkMrkCell"
    let mapCellIdentifier = "mapCell"
    let plainDtCellIdentifier = "plainDtCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //start: use autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        //end: use autolayout constraints
        
        let pDtNib = UINib(nibName: "posterDetailsCell", bundle: nil)
        tableView.register(pDtNib, forCellReuseIdentifier: posterDtCellIdentifier)
        
        let reviewCellNib = UINib(nibName: "ReviewCell", bundle: nil)
        tableView.register(reviewCellNib, forCellReuseIdentifier: ReviewCellIdentifier)
        
        let pChkNib = UINib(nibName: "photoCkInBkMrkCell", bundle: nil)
        tableView.register(pChkNib, forCellReuseIdentifier: photoCkInBkMrkCellIdentifier)
        
        let mNib = UINib(nibName: "mapCell", bundle: nil)
        tableView.register(mNib, forCellReuseIdentifier: mapCellIdentifier)
        
        
        let plDtNib = UINib(nibName: "plainDtCell", bundle: nil)
        tableView.register(plDtNib, forCellReuseIdentifier: plainDtCellIdentifier)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.1
        }
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: posterDtCellIdentifier, for: indexPath) as! posterDetailsCell
                cell.businessNameLabel.text = busObj.name
                cell.distanceLabel.text = busObj.distance
                
                if busObj.imageURL != nil {
                    cell.businessPosterView.setImageWith(busObj.imageURL!)
                }
                
                if busObj.ratingImageURL != nil {
                    cell.ratingsImageView.setImageWith(busObj.ratingImageURL!)
                }
                cell.reviewsLabel.text = "\(busObj.reviewCount!) Reviews"
                cell.categoriesLabel.text = busObj.categories
                
                return cell
            }
            else if(indexPath.row == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCellIdentifier, for: indexPath) as! ReviewCell
                return cell
            }
            else if(indexPath.row == 2){
                let cell = tableView.dequeueReusableCell(withIdentifier: photoCkInBkMrkCellIdentifier, for: indexPath) as! photoCkInBkMrkCell
                return cell

            }
            else if(indexPath.row == 3){
                let cell = tableView.dequeueReusableCell(withIdentifier: mapCellIdentifier, for: indexPath) as! mapCell
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: plainDtCellIdentifier, for: indexPath) as! plainDtCell
                cell.textLabel?.text = busObj.address
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: plainDtCellIdentifier, for: indexPath) as! plainDtCell
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
