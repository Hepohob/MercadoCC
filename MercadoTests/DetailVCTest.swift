//
//  DetailVCTest.swift
//  Mercado
//
//  Created by Aleksei Neronov on 25.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import XCTest
@testable import Mercado

class DetailVCTest: XCTestCase {
 
    var vc:DetailViewController! = nil
    let nameCntr = "DetailViewController"
    let numberText = "Product number"
    let titleText = "Product title"
    let priceText = "Price: 100.00 USD"
    
    override func setUp() {
        super.setUp()
        
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: nameCntr) as! DetailViewController
        
        vc.number = numberText
        vc.titleItem = titleText
        vc.price = priceText
        
        _ = vc.view
        
    }
    
    override func tearDown() {
        super.tearDown()
        vc = nil
    }
    
    func testVC() {
        XCTAssertNotNil(vc, "\(nameCntr) not found")
        XCTAssertNotNil(vc.view, "\(nameCntr) view not found")
    }
    
    func testVCOutlets() {
        XCTAssertNotNil(vc.imageView, "\(nameCntr) imageView not found")
        XCTAssertNotNil(vc.indicator, "\(nameCntr) indicator not found")
        XCTAssertNotNil(vc.numberLabel, "\(nameCntr) numberLabel not found")
        XCTAssertNotNil(vc.titleLabel, "\(nameCntr) titleLabel not found")
        XCTAssertNotNil(vc.priceLabel, "\(nameCntr) priceLabel not found")
        XCTAssertNotNil(vc.descriptionText, "\(nameCntr) descriptionText not found")
    }
    
    func testNumberLabel() {
        let expectedText = numberText
        let actualText = vc.numberLabel?.text
        XCTAssertTrue(actualText == expectedText, "NumberLabel has text \(actualText) but it should have \(expectedText)")
    }
    
    func testTitleLabel() {
        let expectedText = titleText
        let actualText = vc.titleLabel?.text
        XCTAssertTrue(actualText == expectedText, "TitleLabel has text \(actualText) but it should have \(expectedText)")
    }

    func testPriceLabel() {
        let expectedText = priceText
        let actualText = vc.priceLabel?.text
        XCTAssertTrue(actualText == expectedText, "PriceLabel has text \(actualText) but it should have \(expectedText)")
    }
    
    func testIndicatorAnimated() {
        XCTAssertFalse(vc.indicator.isHidden, "Indicator must be not hidden")
    }
    
}
