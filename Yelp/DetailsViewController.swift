//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Deeksha Prabhakar on 10/20/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var button:
    UIButton! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "oval")
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.setImage(image, for: UIControlState.normal)
        button.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        
        let switchButton = UIButton(type: .custom)
        switchButton.isSelected = true
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        switchButton.setImage(notDoneImage, for: .selected)
        switchButton.setImage(doneImage, for: .normal)
        view.addSubview(switchButton)
    }
    
    func buttonPressed() {
        print("button pressed!!")
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        if(button.currentImage == notDoneImage){
            button.setImage(doneImage, for: UIControlState.normal)
        }
        else {
            button.setImage(notDoneImage, for: UIControlState.normal)
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
