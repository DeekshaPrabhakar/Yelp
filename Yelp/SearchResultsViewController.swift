//
//  SearchResultsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var isMapView = false
    let resultCellIdentifier = "ResultsCell"
    var allDistancesInMeters:[Double]!
    var currentFilters = (
        sortMode: "Best Match",
        sortRowIndex:0,
        isDealON: false,
        distance: "Auto",
        distanceRowIndex:0
    )
    var currentCategorySwitchStates = [Int:Bool]()
    
    var loadingStateView:ResultsLoadingIndicatorView?
    var isDataLoading = false
    
    @IBOutlet weak var resultsMapView: UIView!
    @IBOutlet weak var resultsListView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1 mile = 1609.34 meters
        allDistancesInMeters = [0, 0.3 * 1609.34, 1609.34, 5 * 1609.34 , 20 * 1609.34]
        isMapView = false
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //start: use autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        //end: use autolayout constraints
        
        //self.automaticallyAdjustsScrollViewInsets = false
        
        setUpLoadingIndicator()
        
        getOrRefreshBusinesses(searchText: "", distance: nil, sort: nil, categories: nil, deals: nil)
    }
    
    func getOrRefreshBusinesses(searchText: String, distance: Double?, sort: YelpSortMode?, categories: [String]?, deals: Bool?){
        showLoadingIndicator()
        
        Business.searchWithTerm(term: searchText, distance: distance , sort: sort, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if(error != nil) {
                self.hideLoadingIndicator()
                //self.showNetworkErrorView()
            }
            else {
                self.businesses = businesses
                self.tableView.reloadData()
                self.hideLoadingIndicator()
            }
            }
        )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
             getOrRefreshBusinesses(searchText: "", distance: nil, sort: nil, categories: nil, deals: nil)
        } else {
             getOrRefreshBusinesses(searchText: searchText, distance: nil, sort: nil, categories: nil, deals: nil)
        }
    }
    
    private func setUpLoadingIndicator(){
        var middleY = UIScreen.main.bounds.size.height/2;
        middleY  = middleY - self.navigationController!.navigationBar.frame.height
        let frame = CGRect(x: 0, y: middleY, width: UIScreen.main.bounds.size.width, height: ResultsLoadingIndicatorView.defaultHeight)
        loadingStateView = ResultsLoadingIndicatorView(frame: frame)
        loadingStateView!.isHidden = true
        tableView.addSubview(loadingStateView!)
    }
    
    private func showLoadingIndicator(){
        isDataLoading = true
        loadingStateView!.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        isDataLoading = false
        loadingStateView!.stopAnimating()
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let isDealON = filters["deal"] as? Bool
        
        let distanceRow = filters["distanceRowIndex"] as? Int
        let distance = filters["distance"] as? String
        
        let sortByRowIndex = filters["sortByRowIndex"] as? Int
        let sortyBy = filters["sortBy"] as? String
        
        var sortByMode = YelpSortMode.bestMatched
        if(sortyBy == "Best Match"){
            sortByMode = YelpSortMode.bestMatched
        }
        else if(sortyBy == "Distance"){
            sortByMode = YelpSortMode.distance
        }
        else if(sortyBy == "Rating"){
            sortByMode = YelpSortMode.highestRated
        }
        
        let catSwitchStates = filters["categorySwitchStates"] as? [Int:Bool]
        
        //update filters used to pass it to filter view
        currentFilters.sortMode = sortyBy!
        currentFilters.sortRowIndex = sortByRowIndex!
        currentFilters.distanceRowIndex = distanceRow!
        currentFilters.distance = distance!
        currentFilters.isDealON = isDealON!
        
        if(catSwitchStates != nil){
            currentCategorySwitchStates = catSwitchStates!
        }
        
        getOrRefreshBusinesses(searchText: "", distance: allDistancesInMeters[distanceRow!], sort: sortByMode, categories: categories, deals: isDealON)
        
//        Business.searchWithTerm(term: "",distance: allDistancesInMeters[distanceRow!] , sort: sortByMode, categories: categories, deals: isDealON, completion: { (businesses: [Business]?, error: Error?) -> Void in
//            self.businesses = businesses
//            self.tableView.reloadData()
//            }
//        )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellIdentifier, for: indexPath) as! ResultsCell
        
        let busObj = businesses[indexPath.row]
        busObj.businessRowIndex = indexPath.row + 1
        cell.businessObj = busObj
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
        if(segue.destination.isModalInPopover){
        let navController = segue.destination as! UINavigationController
        let filtersVC = navController.topViewController as! FiltersViewController
        filtersVC.delegate = self
        filtersVC.currentFilters = currentFilters
        filtersVC.catSwitchStates = currentCategorySwitchStates
        }
        
    }
    
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

