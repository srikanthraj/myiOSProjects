import Foundation

print("Hello")

var a = ["","","",""]

var b = ["abc":"xyz",
         "dfs": "dfsdf",

]

var emptyArr = [String]()
var emptyDict = [String:Float]()


var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
