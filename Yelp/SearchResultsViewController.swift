//
//  SearchResultsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
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
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var resultsPageOffset = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1 mile = 1609.34 meters
        allDistancesInMeters = [0, 0.3 * 1609.34, 1609.34, 5 * 1609.34 , 20 * 1609.34]
        
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
        
        hideNetworkErrorView()
        setUpLoadingIndicator()
        setupScrollLoadingMoreIndicator()
        
        getOrRefreshBusinesses(searchText: "", distance: nil, sort: nil, categories: nil, deals: nil)
    }
    
    var lastSearchParams = (term: "", distance: 0.0, sort: YelpSortMode.bestMatched, cats: [String](), isDealOn: false)
    
    func getOrRefreshBusinesses(searchText: String, distance: Double?, sort: YelpSortMode?, categories: [String]?, deals: Bool?){
        lastSearchParams.term = searchText
        lastSearchParams.distance = distance ?? 0
        lastSearchParams.sort = sort ?? YelpSortMode.bestMatched
        lastSearchParams.cats = categories ?? []
        lastSearchParams.isDealOn = deals ?? false
        
        showLoadingIndicator()
        
        
        Business.searchWithTerm(term: searchText, offset: resultsPageOffset, distance: distance, sort: sort, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if(error != nil) {
                self.showNetworkErrorView()
                self.hideLoadingIndicator()
                self.loadingMoreView!.stopAnimating()
                
            }
            else {
                self.hideNetworkErrorView()
                if(self.isMoreDataLoading){
                    self.isMoreDataLoading = false
                    for busObj in businesses!{
                        self.businesses.append(busObj)
                    }
                }
                else{
                    self.businesses = businesses
                }
                self.tableView.reloadData()
                self.hideLoadingIndicator()
                self.loadingMoreView!.stopAnimating()
                
            }
            }
        )
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            if (!isMoreDataLoading) {
                
                let scrollViewContentHeight = tableView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
                
                if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                    isMoreDataLoading = true
                    
                    let frame = CGRect(x:0,y: tableView.contentSize.height, width: tableView.bounds.size.width, height:InfiniteScrollActivityView.defaultHeight)
                    
                    loadingMoreView?.frame = frame
                    loadingMoreView!.startAnimating()
                    
                    resultsPageOffset += 20
                    
                    getOrRefreshBusinesses(searchText: lastSearchParams.term, distance: lastSearchParams.distance, sort: lastSearchParams.sort, categories: lastSearchParams.cats, deals: lastSearchParams.isDealOn)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsPageOffset = 0
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
    
    func setupScrollLoadingMoreIndicator() {
        let frame = CGRect(x:0, y:tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    private func showLoadingIndicator(){
        isDataLoading = true
        loadingStateView!.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        isDataLoading = false
        loadingStateView!.stopAnimating()
    }
    
    private func showNetworkErrorView(){
        UIView.animate(withDuration: 0.4, delay: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.networkErrorView.isHidden = false
            self.networkErrorView.frame.size.height = UIScreen.main.bounds.size.height
            
            }, completion: nil)
    }
    
    private func hideNetworkErrorView(){
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.networkErrorView.isHidden = true
            self.networkErrorView.frame.size.height = 0
            }, completion: nil)
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
        
        resultsPageOffset = 0
        getOrRefreshBusinesses(searchText: "", distance: allDistancesInMeters[distanceRow!], sort: sortByMode, categories: categories, deals: isDealON)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if let filtersVC = navController.topViewController as? FiltersViewController{
                filtersVC.delegate = self
                filtersVC.currentFilters = currentFilters
                filtersVC.catSwitchStates = currentCategorySwitchStates
            }
            else if let mapVC = navController.topViewController as? MapsViewController{
                mapVC.businesses = businesses
            }
        }
        else {
            if let detailViewController = segue.destination as? DetailsViewController{
                if let cell = sender as? UITableViewCell{
                    let indexPath = tableView.indexPath(for: cell)
                    let bizObj = businesses![indexPath!.row]
                    detailViewController.busObj = bizObj
                }
            }
        }
        
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

