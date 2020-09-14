//
//  MyBankUITests.swift
//  MyBankUITests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import XCTest

final class MyBankUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
        
        let app = XCUIApplication()
        app.launchArguments = ["UITestingMode"]
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        
        let navBar = app.navigationBars.matching(identifier: "accesssibilityId.account.details.navbar.title").firstMatch
        XCTAssert(navBar.exists)
        
        // Nav header exists
        XCTAssertTrue(navBar.staticTexts["Account Details"].exists)
        XCTAssertEqual(navBar.accessibilityTraits.rawValue, 0) // header trait
        
        sleep(2)
        
        let tableView = app.tables.matching(
            identifier: "accesssibilityId.account.details.table").firstMatch
        XCTAssertTrue(tableView.exists)
        
        let accountDetailsHeader = tableView.otherElements.matching(
            identifier: "accessibilityId.account.details.header").firstMatch
        XCTAssertTrue(accountDetailsHeader.exists)
        XCTAssertEqual(accountDetailsHeader.accessibilityTraits.rawValue, 0) // header trait
        XCTAssertEqual(accountDetailsHeader.label,
                       "Account Arinjoy Big Saver, Account number 062003 29299 9292, with Available funds $10,000.55, and Account balance $999.99")
        
        
        let sectionHeader1 =  tableView.otherElements.matching(
            identifier: "accessibilityId.account.details.transaction.section.header").firstMatch
        XCTAssertTrue(sectionHeader1.exists)
        
        // static text beacause un-tappale cells have .staticText trait
        let staticTextCell1 = tableView.staticTexts.matching(
            identifier: "accessibilityId.account.details.transaction.cell").firstMatch
        XCTAssertTrue(staticTextCell1.exists)
        XCTAssertEqual(staticTextCell1.accessibilityTraits.rawValue, 0)
        XCTAssertEqual(staticTextCell1.label,
                       "Pending transaction, CITYOFSYDNEYPARKINGTX SYDNEY, 1215\nLAST 4 CARD DIGITS: 6901, amount -$855.00")
        
        // tapple cells have .button trait which gets translated as cells here
        let tappableCell1 = tableView.cells.matching(
            identifier: "accessibilityId.account.details.transaction.cell").firstMatch
        XCTAssertTrue(tappableCell1.exists)
        XCTAssertEqual(tappableCell1.accessibilityTraits.rawValue, 0)
        XCTAssertEqual(tappableCell1.label,
                       "Cleared transaction, Wdl ATM CBA ATM CIRCULAR QUAY STATION NSW 221092 AUS 🚗🚕 🚌, amount -$200.00")
        
        tappableCell1.tap()
        
        sleep(1)
        
        let atmViewNavBar = app.navigationBars.staticTexts["ATM Location"].firstMatch
        XCTAssertTrue(atmViewNavBar.exists)
    }
}
