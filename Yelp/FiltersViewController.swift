//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit


class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let brain = YelpBrain()
    let filterCellIdentifier = "FilterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getSection(section: section).sectionLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(section: section).noOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: filterCellIdentifier, for: indexPath) as! FilterCell
        cell.textLabel?.text = getSection(section: indexPath.section).rows[indexPath.row]
        return cell
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
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
            sectionData = (5,"Distance","Dropdown",["Best Match","2 blocks", "6 blocks","1 mile","5 miles"])
        case 2:
            sectionData = (3,"Sort By","Dropdown",["Best Match","Distance","Rating", "Most Reviewed"])
        case 3:
            sectionData = (1,"Category","Dropdown",["Category"])
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
