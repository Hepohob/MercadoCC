//
//  HistoryTVCTest.swift
//  Mercado
//
//  Created by Aleksei Neronov on 25.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import XCTest
import CoreData
@testable import Mercado

class HistoryTVCTest: XCTestCase {
    
    var tvc:HistoryTableViewController! = nil
    let nameCntr = "HistoryTableViewController"
    
    override func setUp() {
        super.setUp()
        tvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: nameCntr) as! HistoryTableViewController
        _ = tvc.view
    }
    
    override func tearDown() {
        super.tearDown()
        tvc = nil
    }
    
    func testTableViewOutlet() {
        XCTAssertNotNil(tvc.tableView, "\(nameCntr) tableView not found")
    }
    
    func testTVCConformToDatasourceProtocols() {
        XCTAssertTrue(tvc .conforms(to: UITableViewDataSource.self), "\(nameCntr) does not conform to UITableView datasource protocol")
    }
    
    func testTVCConformToDelegateProtocols() {
        XCTAssertTrue(tvc .conforms(to: UITableViewDelegate.self), "\(nameCntr) does not conform to UITableView delegate protocol")
    }
    
    func testTVCIsConnectedToDelegate() {
        XCTAssertNotNil(tvc.tableView.delegate, "\(nameCntr) delegate cannot be nil")
    }
    
    func testTVCHasDataSource() {
        XCTAssertNotNil(tvc.tableView.dataSource, "\(nameCntr) datasource cannot be nil")
    }
    
    func testTVCNumberOfRowsInSection() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = []
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }

        let expectedRows = (controller.sections?[0].numberOfObjects)!
        let actualRows = tvc.tableView.numberOfRows(inSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "\(nameCntr) table has \(actualRows) rows but it should have \(expectedRows)")
    }
    
}
