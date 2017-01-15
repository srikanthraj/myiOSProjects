//
//  MeViewController.swift
//  hoBshare
//
//  Created by admin on 2017-01-11.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

import MapKit

class MeViewController: HoBShareViewController, UITextFieldDelegate {

    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        
        if validate() == true
        {
            submit()
        }
        
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        username.delegate = self;
        
    }
    
    override func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
        super.locationManager(manager, didUpdateLocations:locations)
        
        latitudeLabel.text = "Latitude:" + " " + "\(currentLocation!.coordinate.latitude)"
        longitudeLabel.text = "Longitude:" + " " + "\(currentLocation!.coordinate.longitude)"
    }
    
    
    func validate() -> Bool {
        
        var valid = false
        
        if username.text != nil && username.text?.characters.count > 0
        {
            valid = true
        }
        
        return valid
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if validate() == true
        {
            submit()
        }
        
        else
        {
            
        self.showError("Did you enter a username?")
        
        }
        return true
    }
    
    func submit() {
        
        username.resignFirstResponder()
        
        let requestUser = User(userName: username.text!) // We can force unwrap  the text because we have already validated the form!
        
        requestUser.latitude = currentLocation?.coordinate.latitude
        requestUser.longitude = currentLocation?.coordinate.longitude
        
        UserDP().getAccountForUser(requestUser) { (returnedUser) in
            
            
            if returnedUser.status.code == 0
            {
                
                print("User Logged In!!!!!")
                self.myHobbies = returnedUser.hobbies
                
                NSUserDefaults.standardUserDefaults().setValue(requestUser.userId, forKey: "CurrentUserId")
                
                NSUserDefaults().synchronize() // Make sure to call synchronize else your data won't be saved to the disk!
            }
            
            else
                {
                    self.showError(returnedUser.status.statusDescription!) // status comes from SFLBaseModel
            }
        }
    }
    
}
