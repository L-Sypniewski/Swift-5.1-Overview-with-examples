
import Foundation


protocol Airplane: Equatable {
    var type: String {get}
    var capacity: Int {get}
}

struct Airliner: Airplane {
    let type: String = "A320"
    let capacity: Int = 300
}

struct PrivateJet: Airplane {
    let type: String = "Cessna"
    let capacity: Int = 10
}

func createAirplane() -> some Airplane {
    Airliner()
 }


let plane1 = createAirplane()
let plane2 = createAirplane()

print(plane2 == plane1)






protocol Box  {
    associatedtype BoxedType: Equatable
    
    var value: BoxedType {get}
}

struct IntBox: Box {
    var value: Int
}

struct CGFloatBox: Box {
    var value: CGFloat
}


func createBox() -> some Box {
    IntBox(value: Int.random(in: 1...100))
}

//func createBoxWithEquatable() -> some Box where Box.BoxedType == Equatable {
//    IntBox(value: Int.random(in: 1...100))
//}


let box1 = createBox()
let box2 = createBox()
print("Box1: \(box1.value), Box2: \(box2.value)")



struct GenericBox<T: Equatable>: Box {
    var value: T
}

func createGenericBox<T: Equatable>(boxedValue: T) -> some  Box {
    GenericBox(value: boxedValue)
 }


let genericBox1 = createGenericBox(boxedValue: 21.0)
let genericBox2 = createGenericBox(boxedValue: URL(string: "http://google.pl")!)

print("GenericBox1: \(genericBox1.value), GenericBox2: \(genericBox2.value)")










protocol Ancillary: Comparable {
    var name: String {get}
    var price: Int {get}
}

enum CabinType: String, Comparable, CaseIterable {
    
    case eco = "M"
    case business = "C"
    case first = "F"
    
    
    static func < (lhs: CabinType, rhs: CabinType) -> Bool {
        CabinType.allCases.firstIndex(of: lhs)! < CabinType.allCases.firstIndex(of: rhs)!
    }
}


struct SeatUpgrade: Ancillary {
    
    var name: String
    var price: Int
    var cabinType: CabinType

    
    static func < (lhs: SeatUpgrade, rhs: SeatUpgrade) -> Bool {
        lhs.cabinType < rhs.cabinType
      }
}

struct LoungeAccess: Ancillary {

    
    var name: String
    var price: Int
    var priority: Int

    static func < (lhs: LoungeAccess, rhs: LoungeAccess) -> Bool {
        lhs.priority < rhs.priority
    }
    
}

struct OrderData {
    let priority: Int
    let cabinType: CabinType
}

func createAncillary(name: String, price: Int, orderData: OrderData) -> some Ancillary {
//    LoungeAccess(name: name, price: price, priority: orderData.priority)
    SeatUpgrade(name: name, price: price, cabinType: orderData.cabinType)
}


let orderData1 = OrderData(priority: 20, cabinType: .business)
let orderData2 = OrderData(priority: 100, cabinType: .eco)
let orderData3 = OrderData(priority: 0, cabinType: .first)



let ancillary1 = createAncillary(name: "Ancillary1", price: 10, orderData: orderData1)
let ancillary2 = createAncillary(name: "Ancillary2", price: 4, orderData: orderData2)
let ancillary3 = createAncillary(name: "Ancillary3", price: 99, orderData: orderData3)


let ancillariesSorted = [ancillary1, ancillary2, ancillary3].sorted()
print (ancillariesSorted.map{"\($0.name)"})
