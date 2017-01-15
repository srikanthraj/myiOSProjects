//: Playground - noun: a place where people can play

import UIKit



class Model {
    // class definition goes here
    
    var favFoods = ["pizza", "hamburgers", "hot dogs", "coconut" , "grapefruit"]
    
    
    var favMovies = ["Baazigar", "DDLJ" , "Darr", "Main Hoon Na" ,"Anjaam"]
    
    
    var favPlaces = ["Bahamas", "San Francisco" , "Florida" ,"Miami" , "Lake George"]
}


class Controller : Model {

    
    enum type {
        
        case foods
        case movies
        case places
    }
    
    enum order {
        
        case favToLeastFav
        case leastFavToFav
        case alphabetically
        
    }
    
    func askQuestion(type1: type, order1: order) {
        
        print("What are your favorite \(type1)" + "?")
        printFavorites(type1, order2: order1)
    }
    
    
    func printFavorites(type1: type, order2: order) {
        
        var favList = ""
        var orderedFav : [String]!
        
        switch type1 {
            
        case .foods:
            orderedFav = favFoods
       
        case .movies:
            orderedFav = favMovies
            
        case .places:
            orderedFav = favPlaces
            
        }
        
        switch order2 {
            
        case .favToLeastFav:
            break
        
        case .leastFavToFav:
           orderedFav = orderedFav.reverse()
            
        case .alphabetically:
            
            orderedFav = (orderedFav as Array<String>).sort{(str1: String, str2:String) -> Bool in
                return str1.compare(str2) == .OrderedAscending}
            
        }
        
        favList = "My favorite \(type1) are "
        
        for i in 0 ..< 5 {
            
            if i == 0 {
                
                favList += orderedFav[i]
            } else {
                
                if i == 4 {
                    favList += " and " + orderedFav[i] + "."
                }
                else {
                    
                    favList += ", " + orderedFav[i]
                }
            }
            
        }

        print(favList)
}

}

var fav = Controller()
fav.printFavorites(Controller.type.foods,order2: Controller.order.favToLeastFav)
fav.printFavorites(Controller.type.movies, order2: Controller.order.alphabetically)
fav.printFavorites(Controller.type.places, order2: Controller.order.leastFavToFav)


fav.askQuestion(Controller.type.foods, order1: Controller.order.favToLeastFav)
fav.askQuestion(Controller.type.movies, order1: Controller.order.favToLeastFav)
fav.askQuestion(Controller.type.places, order1: Controller.order.favToLeastFav)
