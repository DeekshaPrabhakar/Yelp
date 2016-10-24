//
//  MapsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/23/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {
    var businesses: [Business]!

    @IBOutlet weak var businessesMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView?.tintColor = UIColor.white
        
        businessesMapView.delegate = self
        businessesMapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.05, 0.05)), animated: false)
        businessesMapView.setCenter(CLLocationCoordinate2DMake(37.783333, -122.416667), animated: true)
        addAllBusinessesPins()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       
        if view.annotation is MKUserLocation
        {
            return
        }
        
        //let pTitle = ((view.annotation?.title)!)!
        let pTitle = ((view.annotation?.subtitle)!)!
        let index = Int.init(pTitle)
        let bIndex = index! - 1
        
        let views = Bundle.main.loadNibNamed("pinDetails", owner: nil, options: nil)
        let calloutView = views?[0] as! pinDetails
        
        let businessObj = businesses[bIndex]
        
        calloutView.businessNameLabel.text = businessObj.name
        calloutView.addressLabel.text = businessObj.address
        
        if businessObj.ratingSmallImageURL != nil {
            calloutView.ratingImageView.setImageWith(businessObj.ratingSmallImageURL!)
        }
        calloutView.reviewLabel.text = "\(businessObj.reviewCount!) Reviews"
        calloutView.categoriesLabel.text = businessObj.categories
        calloutView.distanceLabel.text = businessObj.distance
        
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        businessesMapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    func addAllBusinessesPins(){
        var objIndex = 0
        for businessObj in businesses{
            objIndex += 1
            addPin(lat: businessObj.locationCoordinates.lat, longitude: businessObj.locationCoordinates.longitude,itmIndex: objIndex )
        }
    }
    
    func addPin(lat: Double, longitude: Double, itmIndex: Int) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(lat, longitude)
        annotation.coordinate = locationCoordinate
        //annotation.title = "\(itmIndex)"
        annotation.subtitle = "\(itmIndex)"
        businessesMapView.addAnnotation(annotation)
    }
    
    @IBAction func goBackToListView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
