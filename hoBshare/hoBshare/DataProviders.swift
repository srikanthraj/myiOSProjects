//
//  DataProviders.swift
//  hoBshare
//
//  Created by admin on 2017-01-12.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


let serverPath = "http://uci.smilefish.com/HBSRest-Dev/api/"

let endpoint = "HobbyRest"

class UserDP: NSObject {
    
    
    func getAccountForUser(user: User, completion: (User) -> ())
    {
    
        
        let requestUrlString = serverPath + endpoint
        let HTTPMethod = "CREATE_USER"
        let requestModel = user

    
    SFLConnection().ajax(requestUrlString, verb: HTTPMethod, requestBody: requestModel) {
    (returnJSONDict) in
        
        let dict = NSDictionary(dictionary: returnJSONDict)
        
        let returnedUser = User()
        
        returnedUser.readFromJSONDictionary(dict)
    
        completion(returnedUser)
    }
    
    }
    
    
    func fetchUsersForHobby(user: User, hobby: Hobby, completion:(ListOfUsers) -> ())
    {
        // Get everything we need
        
        let requestUrlString = serverPath + endpoint
        let HTTPMethod = "FETCH_USERS_WITH_HOBBY"
        let requestModel = user
        
        // Combine the extra hobby patrameter into the request for this special search type REST Call
        
        requestModel.searchHobby = hobby
        
        // Create the connection (it will start immediately once created).
        
        SFLConnection().ajax(requestUrlString, verb: HTTPMethod, requestBody: requestModel) { (returnJSONDict) in
            
            let dict = NSDictionary(dictionary: returnJSONDict)
            
            let returnedListOfUsers = ListOfUsers()
            
            returnedListOfUsers.readFromJSONDictionary(dict)
        
            completion(returnedListOfUsers)
    }
    
    
}
}

class HobbyDP: NSObject {
    
    
    func fetchHobbies() -> [String : [Hobby]]
    {
        
        // We will provide this code
        
        return ["Technology" : [Hobby(hobbyName:"Video Games"),
            Hobby(hobbyName:"Computers"),
            Hobby(hobbyName:"IDEs"),
            Hobby(hobbyName:"Smartphones"),
            Hobby(hobbyName:"Programming"),
            Hobby(hobbyName:"Electronics"),
            Hobby(hobbyName:"Gadgets"),
            Hobby(hobbyName:"Product Reviews"),
            Hobby(hobbyName:"Computer Repair"),
            Hobby(hobbyName:"Software"),
            Hobby(hobbyName:"Hardware"),
            Hobby(hobbyName:"Apple"),
            Hobby(hobbyName:"Google"),
            Hobby(hobbyName:"Microsoft")]]
        
    }
    
    
    func saveHobbiesForUser(user: User, completion: (User) -> ())
    {
        
        let requestUrlString = serverPath + endpoint
        let HTTPMethod = "SAVE_HOBBIES"
        let requestModel = user
        
        SFLConnection().ajax(requestUrlString, verb: HTTPMethod, requestBody: requestModel) {
            (returnJSONDict) in
            
            let dict = NSDictionary(dictionary: returnJSONDict)
            
            let returnedUser = User()
            
            returnedUser.readFromJSONDictionary(dict)
            
            
            completion(returnedUser)
        }
    }

}