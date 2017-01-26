//
//  CellTest.swift
//  Mercado
//
//  Created by Aleksei Neronov on 25.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import XCTest
@testable import Mercado

class CellTest: XCTestCase {
    
    var tvc:ItemTableViewController! = nil
    var hvc:HistoryTableViewController! = nil
    
    override func setUp() {
        super.setUp()
        tvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemTableViewController") as! ItemTableViewController
        _ = tvc.view
        hvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        _ = hvc.view
    }
    
    override func tearDown() {
        super.tearDown()
        tvc = nil
        hvc = nil
    }
    
    func testTableViewOutlet() {
        XCTAssertNotNil(tvc.tableView, "ItemTableViewController tableView not found")
        XCTAssertNotNil(hvc.tableView, "HistoryTableViewController tableView not found")
    }

    func testCellTVC() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tvc.tableView.dequeueReusableCell(withIdentifier: "Search cell", for: indexPath) as! SearchTableCell
        XCTAssertNotNil(cell, "Cell not found")
        XCTAssertNotNil(cell.indicator, "Cell not contain indicator")
        XCTAssertNotNil(cell.thumb, "Cell not contain thumb")
        XCTAssertNotNil(cell.priceLabel, "Cell not contain priceLabel")
        XCTAssertNotNil(cell.title, "Cell not contain title")
        XCTAssert(cell.title?.text == "Title", "Title doesn't show the right text")
        XCTAssert(cell.priceLabel?.text == "Price label", "PriceLabel doesn't show the right text")
    }

    func testCellHVC() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = hvc.tableView.dequeueReusableCell(withIdentifier: "History cell", for: indexPath) as! SearchTableCell
        XCTAssertNotNil(cell, "Cell not found")
        XCTAssertNotNil(cell.indicator, "Cell not contain indicator")
        XCTAssertNotNil(cell.thumb, "Cell not contain thumb")
        XCTAssertNotNil(cell.priceLabel, "Cell not contain priceLabel")
        XCTAssertNotNil(cell.title, "Cell not contain title")
        XCTAssert(cell.title?.text == "Title", "Title doesn't show the right text")
        XCTAssert(cell.priceLabel?.text == "Price", "PriceLabel doesn't show the right text")
    }

}

