//
//  NearbyViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {

    
    
    
    
    let data = ["Restaurants", "Breakfast & Brunch", "Coffee & Tea", "Order Pickup or Delivery",
                "Reservations", "... More Categories"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView.init(image: UIImage(named: "yelpTitleLogo"))
//        tableView.dataSource = self
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = data[indexPath.row]
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }


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
