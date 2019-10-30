//: [Previous](@previous)

import Foundation
import UIKit

@propertyWrapper
struct MoneyStringified {
    private var currency: String
    private var amount: String
    
    var projectedValue: Bool {
        Int(amount) ?? 0 > 5
    }
    
    init(wrappedValue: String, currency: String) {
        self.amount = wrappedValue
        self.currency = currency
    }
    
    init(wrappedValue: String) {
        self.amount = wrappedValue
        self.currency = "<unknown currency>"
    }
    
    init(currency: String) {
        self.amount = "0"
        self.currency = currency
    }
    
    
    var wrappedValue: String {
        get { return "\(amount) \(currency)" }
        set { amount = newValue }
    }
}

protocol Money {
    var amount: String {get set}
    var amIRich: Bool {get}
}


struct BritishMoney: Money {
    
    @MoneyStringified(currency: "GPB") var amount: String
    
    var amIRich: Bool {
        $amount
    }
    
    init(amount: String) {
        self.amount = amount
    }
}

struct PolishMoney {
    @MoneyStringified(currency: "PLN") var amount: String
    
    init(amount: String) {
        self.amount = amount
    }
}

struct GermanMoney {
    var amount: MoneyStringified
    
    
    init(amount: String, currency: String) {
        self.amount = MoneyStringified(wrappedValue: amount, currency: currency)
    }
}


var gpb = BritishMoney(amount: "50")

var pln = PolishMoney(amount: "4")
print(gpb.amount)
print(pln.amount)

print(gpb.$amount) //projected values
print(pln.$amount)

print("Is British rich: \(gpb.amIRich)")

var eur = GermanMoney(amount: "14", currency: "EUR")
print(eur.amount.wrappedValue)


//**************************

@propertyWrapper
struct ColouredLabel {
    
    private var wrappedLabel: UILabel
    private var color: UIColor
    
    init() {
        wrappedLabel = UILabel()
        color = wrappedLabel.textColor
    }
    
    init(wrappedValue: UILabel) {
        self.wrappedLabel = wrappedValue
        color = wrappedLabel.textColor
    }
    
    init(wrappedValue: UILabel, color: UIColor) {
        self.wrappedLabel = wrappedValue
        self.color = color
    }
    
    init(color: UIColor) {
        self.wrappedLabel = UILabel()
        self.color = color
    }
    
    
    
    var wrappedValue: UILabel {
        set { wrappedLabel = newValue }
        get {
            wrappedLabel.textColor = color
            return wrappedLabel
        }
    }
}

@propertyWrapper
struct BoldLabel {
    
    private var wrappedLabel: UILabel
    
    init() {
        wrappedLabel = UILabel()
    }
    
    init(wrappedValue: UILabel) {
        self.wrappedLabel = wrappedValue
    }
    
    var wrappedValue: UILabel {
        set { wrappedLabel = newValue }
        get {
            wrappedLabel.font = UIFont.boldSystemFont(ofSize: wrappedLabel.font.pointSize)
            return wrappedLabel
        }
    }
}

protocol LabelWrapper {
    var label: UILabel {get set}
    
}

@propertyWrapper
struct ChainableBoldLabel: LabelWrapper {
    
    var label: UILabel
    private var wrapper: LabelWrapper
    
      
      init(wrappedValue: LabelWrapper) {
            self.wrapper = wrappedValue
            self.label = wrappedValue.label
      }
      
      var wrappedValue: LabelWrapper {
        set {
            wrapper = newValue
            label = newValue.label
        }
        mutating get {
              label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
              wrapper.label = label
              return wrapper
          }
      }
}

@propertyWrapper
struct ChainableColouredLabel: LabelWrapper {
    
    var label: UILabel
    private var wrapper: LabelWrapper
    
    private var color: UIColor
    
    
    init(wrappedValue: LabelWrapper) {
          self.wrapper = wrappedValue
          self.label = wrappedValue.label
          self.color = .black
    }
    
    init(wrappedValue: LabelWrapper, color: UIColor) {
        self.wrapper = wrappedValue
        self.label = wrappedValue.label
        self.color = color
    }
    
    var wrappedValue: LabelWrapper {
         set {
                   wrapper = newValue
                   label = newValue.label
               }
       mutating get {
            label.textColor = color
            wrapper.label = label
            return wrapper
        }
    }
}


class ViewWithSomeLabels: UIView {
    
    @ColouredLabel(color: .green) private var label1: UILabel
    @ColouredLabel(color: .red)  private var label2 = UILabel()
    @BoldLabel private var label3 = ColouredLabel(color: .red).wrappedValue
//    @ChainableBoldLabel @ChainableColouredLabel(color: .red) private var chainableWrapper: LabelWrapper //Multiple wrappers are not supported
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        
        label1.text = "The first label"
        label2.text = "Label on the bottom"
        label3.text = "The last one"
        
        //        @ColouredLabel(color: .blue) var label4 = UILabel()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setContraints() {
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            label2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor),
            
            label3.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor),
        ])
    }
}


ViewWithSomeLabels(frame: CGRect(x: 0, y: 0, width: 300, height: 300))



// *************



@propertyWrapper
struct TransformCollection<T>{
    
    private var collection: Array<T>
    private var transformFunction: ((T) -> T)
    
    init(wrappedValue: Array<T>) {
        self.collection = wrappedValue
        transformFunction = {$0}
    }
    
    init(wrappedValue: Array<T>, transformFunction: @escaping ((T) -> T)) {
        self.collection = wrappedValue
        self.transformFunction = transformFunction
    }
    
    init(transformFunction: @escaping ((T) -> T)) {
        self.collection = []
        self.transformFunction = transformFunction
    }
    
    var wrappedValue: Array<T> {
        get { collection.map(transformFunction) }
        set { collection = newValue}
    }
    
}

struct LotteryResult {
    
    private static let transfromArray: ((Int) -> Int) = {$0 * 4}
    
    @TransformCollection(transformFunction: transfromArray) var numbers = [1,2,3]
    
}


print(LotteryResult().numbers)
