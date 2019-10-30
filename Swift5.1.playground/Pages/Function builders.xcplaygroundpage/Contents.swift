//: [Previous](@previous)

import Foundation

@_functionBuilder
class CharRowBuilder {
  
     static func buildBlock(_ children: String...) -> String {
        
        var newString = ""
        
        for string in children {
            newString += string
        }
        
        return newString
    }
}

@_functionBuilder
class StringFromIntBuilder {
  
     static func buildBlock(_ children: Int...) -> String {
        
        var newString = ""
        
        for int in children {
            newString += String(int)
        }
        
        return newString
    }
}

@_functionBuilder
class CharColumnBuilder {
  
     static func buildBlock(_ children: String...) -> String {
        
        var newString = ""
        
        for string in children {
            newString += "\(string)\n"
        }
        
        return newString
    }
}



@CharRowBuilder
func getRow() -> String {
    "A"
    "B"
    "C"
}

@CharColumnBuilder
func getColumn() -> String {
    "1"
    "2"
    "3"
}

print("\n\n")
print ("getRow:\n\(getRow())\n****")
print ("getColumn:\n\(getColumn())\n\n")




struct Drawing {
    var content: String

    init(@CharColumnBuilder _ content: () -> String) {
        self.content = content()
    }
    
}


let someDrawing = Drawing {
    "***********"
    "  ******   "
    "***********"
    "  ******   "
    "    **     "
    "***********"
    getColumn()
}

print(someDrawing.content)
print("\n\n\n")

@StringFromIntBuilder
func buildStringFromInts() -> String {
    1
    2
    4
    700
}

print(buildStringFromInts())
