//
//  SearchResultsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var isMapView = false
    let resultCellIdentifier = "ResultsCell"
    
    @IBOutlet weak var resultsMapView: UIView!
    
    @IBOutlet weak var resultsListView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func toggleMapButton(_ sender: AnyObject) {
        
        if(isMapView){
            navigationItem.rightBarButtonItem?.title = "Map"
            UIView.transition(from: resultsMapView, to: resultsListView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        }
        else{
            navigationItem.rightBarButtonItem?.title = "List"
            UIView.transition(from: resultsListView, to: resultsMapView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        }
        isMapView = !isMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 150
        
        isMapView = false
        
        getOrRefreshBusinesses()
    }
    
    func getOrRefreshBusinesses(){
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            }
        )
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellIdentifier, for: indexPath) as! ResultsCell
        
        let busObj = businesses[indexPath.row]
        cell.businessObj = busObj
       print(indexPath.row)
//        cell.businessNameLbl.text = busObj.name
//        cell.distanceLabel.text = busObj.distance
//        cell.priceRangeLabel.text = "$$"
//        if busObj.imageURL != nil {
//            cell.businessImageView.setImageWith(busObj.imageURL!)
//        }
//        
//        if busObj.ratingImageURL != nil {
//            cell.ratingImageView.setImageWith(busObj.ratingImageURL!)
//        }
//        cell.noOfReviewsLabel.text = String(describing: busObj.reviewCount)
//        
//        cell.addressLabel.text = busObj.address
//        cell.categoriesLabel.text = busObj.categories
//        
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        else
        {
            return 0
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

// SearchBar methods
extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        //doSearch()
    }
}

