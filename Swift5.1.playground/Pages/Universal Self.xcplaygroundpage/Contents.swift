//: [Previous](@previous)

import Foundation


class Cat {
    class var sound: String { "meow"}
    
    func talk() {
        print(Self.sound) 
    }
}

class Lion: Cat {
   override class var sound: String { "roar"}
}



Cat().talk()
Lion().talk()
