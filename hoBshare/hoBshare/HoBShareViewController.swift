//
//  HoBShareViewController.swift
//  hoBshare
//
//  Created by admin on 2017-01-11.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MapKit

class HoBShareViewController: UIViewController, CLLocationManagerDelegate , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
    
    let availableHobbies: [String:[Hobby]] = HobbyDP().fetchHobbies()

    var myHobbies: [Hobby]? {
        
        didSet{
            self.hobbiesCollectionView.reloadData()
            
            self.saveHobbiesToUserDefaults() // Saves Hobbies to disk
        }
    }

    // Location related events
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated);
        locationManager.delegate = self;
        
        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        
        else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            
            // First stop location update and start
            
            locationManager.stopUpdatingLocation()
            
            locationManager.startUpdatingLocation()
        }
        
       getHobbies()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
     
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways
        {
            
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last!
        
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print(error.debugDescription)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if collectionView == hobbiesCollectionView
        {
            return 1
            
        }
        
        else {
            return availableHobbies.keys.count
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == hobbiesCollectionView
        {
            
            guard myHobbies != nil else
            {
                return 0
            }
            
            return myHobbies!.count
        }
    
    else {
    
    let key = Array(availableHobbies.keys)[section]
    
    return availableHobbies[key]!.count
    
    }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: HobbyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("HobbyCollectionViewCell", forIndexPath: indexPath) as! HobbyCollectionViewCell
        
        
        if collectionView == hobbiesCollectionView
        {
            // Configure One way for user selected hobbies
            
            let hobby = myHobbies![indexPath.item]
            
            cell.hobbyLabel.text = hobby.hobbyName
        }
        
        else {
            
            // Use another way for available hobbies
            
            let key = Array(availableHobbies.keys)[indexPath.section]
            
            let hobbies = availableHobbies[key]
            
            let hobby = hobbies![indexPath.item]
            
            cell.hobbyLabel.text = hobby.hobbyName
            
        }
        
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
        
    }
    
    // Below to Resize the cell view automatically according to the number of hobbies present , using the UICollectionViewDelegateFlowLayout delegate
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var availableWidth: CGFloat!
        
        let cellHeight: CGFloat! = 54 // Assume 54 is the height
        
        var numberOfCells: Int!
        
        if collectionView == hobbiesCollectionView
        {

            numberOfCells = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            
            let padding = 10
            
            availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells! - 1))
        }
        
        else
        {
            numberOfCells = 2 // just setting up
            
            let padding = 10
            
            availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells! - 1))
        }
        
        let dynamicCellWidth = availableWidth / CGFloat(numberOfCells!)
        
        let dynamicCellSize = CGSizeMake(dynamicCellWidth , cellHeight)
        
        return dynamicCellSize
    }
    
    
    func saveHobbiesToUserDefaults() {
        
        let hobbyData = NSKeyedArchiver.archivedDataWithRootObject(myHobbies!)
        
        NSUserDefaults.standardUserDefaults().setValue(hobbyData, forKey: "MyHobbies")
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func showError(message: String)
    {
        let alert = UIAlertController(title: kAppTitle, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Dismiss" , style: .Default, handler : { (action) in
            alert.dismissViewControllerAnimated (true, completion: nil)
        })
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func getHobbies()
    {
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("MyHobbies") as? NSData
        {
            
            
            let savedHobbies = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Array<Hobby>
            
            myHobbies = savedHobbies
            
            print("Inside Get Hobbies \t \(myHobbies)")
        }
    }

    
    
}
