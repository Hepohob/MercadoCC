//
//  RESTTest.swift
//  Mercado
//
//  Created by Aleksei Neronov on 25.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import XCTest
import CoreData
@testable import Mercado

class RESTTest: XCTestCase {
    
    var url = ""
    let indexPath = IndexPath(row: 0, section: 0)
    
    override func setUp() {
        super.setUp()
        url = SEARCH_URL + "Macbook" + URL_SUFFIX
    }
    
    override func tearDown() {
        super.tearDown()
        url = ""
    }
    
    func testREST() {
        REST.loadList(for: url) { 
            let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
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
            //testing number of objects in Coredata after rest request
            XCTAssertTrue(controller.sections?[0].numberOfObjects == 50, "Loaded less than 50 elements")
            
            //testing of elements received by REST
            let item = controller.object(at: self.indexPath)
            XCTAssertTrue((item.id?.characters.count)! > 0, "Not loaded id from server.")
            XCTAssertTrue((item.currency?.characters.count)! > 0, "Not loaded currency from server.")
            XCTAssertTrue((item.thumb?.characters.count)! > 0, "Not loaded thumb url link from server.")
            XCTAssertTrue((item.title?.characters.count)! > 0, "Not loaded title from server.")
            XCTAssertTrue(item.price > 0, "Not loaded price from server.")
        }
    }

    
}
