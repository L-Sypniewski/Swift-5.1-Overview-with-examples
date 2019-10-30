var numbers1 = [60, 50, 30, 10]
let numbers2 = [20, 90, 10, 50, 40]


let diffs = numbers2.difference(from: numbers1) //CollectionDifference<ChangeElement>, insertions, removals



diffs.forEach {change in
    switch change {
    case .remove(let offset, let element, let associatedWith):
        print("Remove: Offset: \(offset), Element: \(element), associatedWith: \(associatedWith)\n")
        case .insert(let offset, let element, let associatedWith):
               print("Insert: Offset: \(offset), Element: \(element), associatedWith: \(associatedWith)\n")
    }
}


let diffsInferringMoves = diffs.inferringMoves()

diffsInferringMoves.forEach {change in
    switch change {
    case .remove(let offset, let element, let associatedWith):
        print("Remove inferring moves: Offset: \(offset), Element: \(element), associatedWith: \(associatedWith)\n")
        case .insert(let offset, let element, let associatedWith):
               print("Insert inferring moves: Offset: \(offset), Element: \(element), associatedWith: \(associatedWith)\n")
    }
}



for change in diffs {
    switch change {
    case .remove(let offset, _, _):
        numbers1.remove(at: offset)
    case .insert(let offset, let element, _):
        numbers1.insert(element, at: offset)
    }
}
print(numbers1)

numbers1 = numbers2.applying(diffs) ?? []


//The association, called associatedWith, is an index representing the other change offset:
//if we’re looking at a .insert change, the associatedWith index
//will be equal to the associated .remove offset index, and vice versa.
