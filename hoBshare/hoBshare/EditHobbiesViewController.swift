//
//  EditHobbiesViewController.swift
//  hoBshare
//
//  Created by admin on 2017-01-11.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class EditHobbiesViewController: HoBShareViewController {

    
    @IBOutlet weak var availableHobbiesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
            
            self.availableHobbiesCollectionView.delegate = self
        
        
        
        }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
       let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HobbyCategoryHeader", forIndexPath: indexPath)
        
       
        
        (reusableView as! HobbiesCollectionViewHeader).categoryLabel.text = Array(availableHobbies.keys)[indexPath.section]
        
        
       
        
        return reusableView
        
    }
    
    
    func saveHobbies()
    {
        
        let requestUser = User()
        
        requestUser.userId = NSUserDefaults.standardUserDefaults().valueForKey("CurrentUserId") as?
        String
        
        print("Save Hobbies : User id is\t \(requestUser.userId)")
        
        if let myHobbies = self.myHobbies
        {
            
            requestUser.hobbies = myHobbies
        }
        
        
        HobbyDP().saveHobbiesForUser(requestUser) { (returnedUser) -> () in
            
            
            if returnedUser.status.code == 0
            {
                
                
                self.saveHobbiesToUserDefaults()
                self.hobbiesCollectionView.reloadData()
                print("Save Hobbies status code = 0")
            }
                
            else
            {
                self.showError(returnedUser.status.statusDescription!) // status comes from SFLBaseModel
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        if collectionView == availableHobbiesCollectionView
        {
            
            let key = Array(availableHobbies.keys)[indexPath.section]
            
            let hobbies = availableHobbies[key]
            
            let hobby = hobbies![indexPath.item]
            
            if myHobbies?.contains( { $0.hobbyName == hobby.hobbyName } ) == false {
                
                if myHobbies!.count < kMaxHobbies
                {
                    myHobbies! += [hobby]
                    self.saveHobbies()
                }
                
                else
                {
                 
                    
                    let alert = UIAlertController(title: kAppTitle, message: "You many select upto \(kMaxHobbies) hobbies , Please delete a hobby and then try again", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "Dismiss" , style: .Default, handler : { (action) in
                        alert.dismissViewControllerAnimated (true, completion: nil)
                    })
                    
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
        
        else
        {
            
            let alert = UIAlertController(title: kAppTitle, message: "Would you like to delete this hobby?", preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete" , style: .Destructive, handler : { (action) in
            
            // delete the item
            
            self.myHobbies!.removeAtIndex(indexPath.item)
            self.saveHobbies()
                
            })
        
            let cancelAction = UIAlertAction(title: "Cancel" , style: .Default, handler : { (action) in
                alert.dismissViewControllerAnimated (true, completion: nil)
            })
            
             alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
    }
    
}
