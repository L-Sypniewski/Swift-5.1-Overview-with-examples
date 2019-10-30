//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Łukasz Sypniewski on 31/10/2019.
//  Copyright © 2019 Łukasz Sypniewski. All rights reserved.
//

import UIKit

//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport


enum Airline: String, CaseIterable {
    case lufthansa
    case swiss
    case austrian
}

struct Flight: Hashable {
    var flightNumber: String
    var departureAirport: String
}

struct FlightList {
    var lufthansa: [Flight] = []
    var swiss: [Flight] = []
    var austrian: [Flight] = []
    
    var count: Int {lufthansa.count + swiss.count + austrian.count}
}

class DiffableTableViewController: UIViewController {
    
    private let cellReuseIdentifier = "cell"
    private var dataSource:  UITableViewDiffableDataSource<Airline, Flight>!
    
    private var flightList = DiffableTableViewController.createInitilalFlightList()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate ([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.dataSource = createDataSource()
        update(with: flightList)
    }
    
    func update(with list: FlightList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Airline, Flight>()
        snapshot.appendSections(Airline.allCases)
        
        snapshot.appendItems(list.lufthansa, toSection: .lufthansa)
        snapshot.appendItems(list.swiss, toSection: .swiss)
        snapshot.appendItems(list.austrian, toSection: .austrian)
        
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func remove(flight: Flight, animate: Bool = true) {
        print("Number of elements in array before removing: \(flightList.count)")
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([flight])
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

extension DiffableTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected row at: \(indexPath)")
        if (indexPath.section == 0) {
            print("Removing: \(flightList.lufthansa[indexPath.row])")
            remove(flight: flightList.lufthansa[indexPath.row])
            flightList.lufthansa.remove(at: indexPath.row)
        }
        if (indexPath.section == 1) {
            print("Removing: \(flightList.swiss[indexPath.row])")
            remove(flight: flightList.swiss[indexPath.row])
            flightList.swiss.remove(at: indexPath.row)
        }
        if (indexPath.section == 2) {
            print("Removing: \(flightList.austrian[indexPath.row])")
            remove(flight: flightList.austrian[indexPath.row])
            flightList.austrian.remove(at: indexPath.row)
        }
        
    }
}

extension DiffableTableViewController {
    
    func createDataSource() -> UITableViewDiffableDataSource<Airline, Flight>? {
        let reuseIdentifier = cellReuseIdentifier
        
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, flight in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                )
                
                cell.textLabel?.text = flight.flightNumber
                cell.detailTextLabel?.text = flight.departureAirport
                return cell
        }
        )
    }
}


extension DiffableTableViewController {
    
    static func createInitilalFlightList() -> FlightList {
        
        let lufthansaFlights = [
            Flight(flightNumber: "LH400", departureAirport: "FRA"),
            Flight(flightNumber: "LH1604", departureAirport: "GDN"),
            Flight(flightNumber: "LO5356", departureAirport: "WAW")
        ]
        
        let austrianFlights = [
            Flight(flightNumber: "OS8543", departureAirport: "VIE"),
            Flight(flightNumber: "OS9743", departureAirport: "MUC"),
            Flight(flightNumber: "OS3331", departureAirport: "MAD")
        ]
        
        let swissFlights = [
            Flight(flightNumber: "LX3363", departureAirport: "ZRH"),
            Flight(flightNumber: "LX443", departureAirport: "BAS"),
            Flight(flightNumber: "LX122", departureAirport: "SZY")
        ]
        
        return FlightList(lufthansa: lufthansaFlights, swiss: swissFlights, austrian: austrianFlights)
    }
}


let vc = DiffableTableViewController()

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
