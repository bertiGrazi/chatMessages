import UIKit

// How to create and use closures

//01
let sayHello = { (name: String) -> String in
    "Hi \(name)!"
}

sayHello("Grazi")

//02
func greetUser() {
    print("Hi there!")
}
var greetCopy: () -> Void = greetUser

//03
func getUserData(for id: Int) -> String {
    if id == 1989 {
        return "Taylor Swift"
    } else {
        return "Anonymous"
    }
}

let data: (Int) -> String = getUserData
let user = data(1989)
let userTwo = data(1981)
print("User: \(user)")
print("UserTwo: \(userTwo)")

//04
let team = ["Beyoncé, Rihanna, Lady Gaga, Madonna"]
let sortedTeam = team.sorted()
print(sortedTeam)

func captainFirstSorted(name1: String, name2: String) -> Bool {
    if name1 == "Madonna" {
        return true
    } else if name2 == "Madonna" {
        return false
    }
    
    return name1 < name2
}

//let captainFirstTeam = team.sorted(by: captainFirstSorted)
//print(captainFirstTeam)

//05
let captainFirstTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Beyoncé" {
        return true
    } else if name2 == "Beyoncé" {
        return false
    }
    
    return name1 < name2
})


print(captainFirstTeam)

//This code is valid Swift.
let learnSwift = {
    print("Closures are like functions")
}
learnSwift()

//Oops – that's not correct. The parentheses after upgrade should not be there..
//let upgrade() = {
//    print("Upgrading...")
//}
//upgrade()

//Why are Swift’s closure parameters inside the braces?
//Closures take their parameters inside the brace to avoid confusing Swift: if we had written let payment = (user: String, amount: Int) then it would look like we were trying to create a tuple, not a closure, which would be strange.

//Q01:
var cleanRoom = { (name: String) in
    print("I'm cleaning the \(name).")
}
cleanRoom("kitchen")

//Q02:
var sendMessage = { (message: String) in
    if message != "" {
        print("Sending to Twitter: \(message)")
    } else {
        print("Your message was empty.")
    }
}

sendMessage("Hello, Dina!")

//Q03:
var click = { (button: Int) in
    if button >= 0 {
        print("Button \(button) was clicked.")
    } else {
        print("That button doesn't exist.")
    }
}

click(-1)

//Q04:
let printDocument = { (copies: Int) in
    for _ in 1...copies {
        print("Printing document...")
    }
}

printDocument(2)

//Q05:
var shareWinnings = { (amount: Double) in
    let half = amount/2
    print("It's \(half) for me and \(half) for you.")
}
shareWinnings(50)

//How to use trailing closures and shorthand syntax
let group = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

//let sorted = group.sorted(by: { a, b -> Bool in
//                          if a == "Suzanne" {
//                          return true
//                          } else if b == "Suzanne" {
//                          return false
//                          }
//
//                          return a < b
//
//})
//
//print(sorted)

let sorted = group.sorted {
                          if $0 == "Suzanne" {
                          return true
                          } else if $1 == "Suzanne" {
                          return false
                          }
                          
                          return $0 < $1

}

print(sorted)
//["Suzanne", "Gloria", "Piper", "Tasha", "Tiffany"]

let reverseTeam = group.sorted { $0 > $1 }
print(reverseTeam)
//["Tiffany", "Tasha", "Suzanne", "Piper", "Gloria"]

let tOnly = group.filter { $0.hasPrefix("T") }
print(tOnly)
//["Tiffany", "Tasha"]

let uppercaseTeam = group.map { $0.uppercased() }
print(uppercaseTeam)
//["GLORIA", "SUZANNE", "PIPER", "TIFFANY", "TASHA"]
