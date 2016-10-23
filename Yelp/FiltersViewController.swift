//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CategoryCellDelegate, DealCellDelegate, DistanceCellDelegate, SortByCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let brain = YelpBrain()
    let dealCellIdentifier = "DealCell"
    let distanceCellIdentifier = "DistanceCell"
    let sortByCellIdentifier = "SortByCell"
    let categoryCellIdentifier = "CategoryCell"
    let selectedCellIdentifier = "SelectedDropdownCell"
    let seeAllCellIdentifier = "SeeAllCell"
    
    var allCategories:[[String:String]]!
    var categorySwitchStates = [Int:Bool]()
    var isDealOnState = [Int:Bool]()
    var distanceState = (rowSelected:0,rowSelectedLabel: "Auto")
    var sortByState = (rowSelected:0,rowSelectedLabel: "Best Match")
    
    var distanceExpanded = false
    var sortByExpanded = false
    var categoryExpanded = false
    
    var allDistances:[String]!
    var allSortByOptions:[String]!
    
    var currentFilters:(sortMode: String, sortRowIndex: Int, isDealON: Bool, distance: String, distanceRowIndex: Int)!
    var catSwitchStates:[Int:Bool]!

    weak var delegate:FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 43
        
        allCategories = brain.getAllCategories()
        allDistances = ["Auto","0.3 miles", "1 mile","5 mile","20 miles"]
        allSortByOptions = ["Best Match","Distance","Rating", "Most Reviewed"]
        
        distanceState.rowSelected = currentFilters.distanceRowIndex
        distanceState.rowSelectedLabel = currentFilters.distance
        
        sortByState.rowSelectedLabel = currentFilters.sortMode
        sortByState.rowSelected = currentFilters.sortRowIndex
        
        isDealOnState = [0: currentFilters.isDealON]
        categorySwitchStates = catSwitchStates
        
        let dealNib = UINib(nibName: "DealCell", bundle: nil)
        tableView.register(dealNib, forCellReuseIdentifier: dealCellIdentifier)
        
        let selectedCellNib = UINib(nibName: "SelectedDropdownCell", bundle: nil)
        tableView.register(selectedCellNib, forCellReuseIdentifier: selectedCellIdentifier)
        
        let distanceSwitchNib = UINib(nibName: "DistanceCell", bundle: nil)
        tableView.register(distanceSwitchNib, forCellReuseIdentifier: distanceCellIdentifier)
        
        let sortBySwitchNib = UINib(nibName: "SortByCell", bundle: nil)
        tableView.register(sortBySwitchNib, forCellReuseIdentifier: sortByCellIdentifier)
        
        let categorySwitchNib = UINib(nibName: "CategoryCell", bundle: nil)
        tableView.register(categorySwitchNib, forCellReuseIdentifier: categoryCellIdentifier)
        
        let SeeAllCellNib = UINib(nibName: "SeeAllCell", bundle: nil)
        tableView.register(SeeAllCellNib, forCellReuseIdentifier: seeAllCellIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getSection(section: section).sectionLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            if(distanceExpanded){
                return getSection(section: section).noOfRows
            }
            else{
                return 1
            }
        }
        else if(section == 2){
            if(sortByExpanded){
                return getSection(section: section).noOfRows
            }
            else{
                return 1
            }
        }
        else if(section == 3){
            if(categoryExpanded){
                return getSection(section: section).noOfRows
            }
            else{
                return 4
            }
        }
        else{
            return getSection(section: section).noOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 3){
            if(categoryExpanded){
                let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
                cell.categoryLabel.text = allCategories[indexPath.row]["name"]
                cell.delegate = self
                cell.categorySwitch.isOn = categorySwitchStates[indexPath.row] ??  false
                return cell
            }
            else{
                if(indexPath.row == 3){
                    let cell = tableView.dequeueReusableCell(withIdentifier: seeAllCellIdentifier, for: indexPath) as! SeeAllCell
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
                    cell.categoryLabel.text = allCategories[indexPath.row]["name"]
                    cell.delegate = self
                    cell.categorySwitch.isOn = categorySwitchStates[indexPath.row] ??  false
                    return cell
                }
            }
        }
        else if(indexPath.section == 1){
            if(distanceExpanded){
                let cell = tableView.dequeueReusableCell(withIdentifier: distanceCellIdentifier, for: indexPath) as! DistanceCell
                cell.distanceLabel.text = getSection(section: indexPath.section).rows[indexPath.row]
                cell.distanceDelegate = self
                cell.distanceSwitch.isOn = (distanceState.rowSelected == indexPath.row)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: selectedCellIdentifier, for: indexPath) as! SelectedDropdownCell
                cell.selectedLabel.text = distanceState.rowSelectedLabel
                return cell
            }
        }
        else if(indexPath.section == 2){
            if(sortByExpanded){
                let cell = tableView.dequeueReusableCell(withIdentifier: sortByCellIdentifier, for: indexPath) as! SortByCell
                cell.sortByLabel.text = getSection(section: indexPath.section).rows[indexPath.row]
                cell.sortByDelegate = self
                cell.sortBySwitch.isOn = (sortByState.rowSelected == indexPath.row)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: selectedCellIdentifier, for: indexPath) as! SelectedDropdownCell
                cell.selectedLabel.text = sortByState.rowSelectedLabel
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: dealCellIdentifier, for: indexPath) as! DealCell
            cell.dealDelegate = self
            cell.dealLabel?.text = getSection(section: indexPath.section).rows[indexPath.row]
            cell.dealSwitch.isOn = isDealOnState[indexPath.row] ??  false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            distanceExpanded = !distanceExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
        else if(indexPath.section == 2){
            sortByExpanded = !sortByExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
        else if(indexPath.section == 3){
            categoryExpanded = !categoryExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    func dealSwitchCell(dealSwitchCell: DealCell, didChangeValue: Bool) {
        let indexPath = tableView.indexPath(for: dealSwitchCell)!
        isDealOnState[indexPath.row] = didChangeValue
    }
    
    func categorySwitchCell(categorySwitchCell: CategoryCell, didChangeValue: Bool) {
        let indexPath = tableView.indexPath(for: categorySwitchCell)!
        categorySwitchStates[indexPath.row] = didChangeValue
    }
    
    func distanceSwitchCell(distanceSwitchCell: DistanceCell, didChangeValue: Bool) {
        if(didChangeValue){
            let indexPath = tableView.indexPath(for: distanceSwitchCell)!
            distanceState = (rowSelected:indexPath.row,rowSelectedLabel: allDistances[indexPath.row])
            distanceExpanded = !distanceExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    func sortBySwitchCell(sortBySwitchCell: SortByCell, didChangeValue: Bool) {
        if(didChangeValue){
            let indexPath = tableView.indexPath(for: sortBySwitchCell)!
            sortByState = (rowSelected:indexPath.row,rowSelectedLabel: allSortByOptions[indexPath.row])
            sortByExpanded = !sortByExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        
        for (row,isSelected) in categorySwitchStates {
            if(isSelected){
                selectedCategories.append(allCategories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        var dealOn = false
        
        for (_, isSelected) in isDealOnState{
            if(isSelected){
                dealOn = true
            }
        }
        
        filters["deal"] = dealOn as AnyObject?
        
        filters["sortBy"] = sortByState.rowSelectedLabel as AnyObject?
        filters["sortByRowIndex"] = sortByState.rowSelected as AnyObject?
        
        filters["distanceRowIndex"] = distanceState.rowSelected as AnyObject?
        filters["distance"] = distanceState.rowSelectedLabel as AnyObject?
        
        filters["categorySwitchStates"] = categorySwitchStates as AnyObject?
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelSearch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func getSection(section: Int) -> (noOfRows:Int,sectionLabel: String, rowType: String, rows: [String]) {
        var sectionData:(Int,String,String, [String])?
        switch section {
        case 0:
            sectionData = (1,"","Switch",["Offering a Deal"])
        case 1:
            sectionData = (5,"Distance","Dropdown",["Auto","0.3 miles", "1 mile","5 mile","20 miles"])
        case 2:
            sectionData = (3,"Sort By","Dropdown",["Best Match","Distance","Rating"])
        case 3:
            sectionData = (allCategories.count,"Category","Dropdown",[])
        default:
            break
        }
        return sectionData!
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
