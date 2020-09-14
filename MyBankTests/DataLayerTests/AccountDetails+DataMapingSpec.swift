//
//  AccountDetails+DataMapingSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyBank

final class AccountDetailsDataMapingSpec: QuickSpec {

    override func spec() {
        
        describe("Account Details Full Data Mapping Spec") {
            
            var testJSONData: Data!
            
            context("correct JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "account_details_full")
                }
                
                it("should successfully decode to valid `FullAccountDetailsResponse` object") {
                    
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(DateFormattingHelper.shortDate)
                    
                    let mappedItem = try? jsonDecoder.decode(FullAccountDetailsResponse.self, from: testJSONData)

                    // The entire structure is mapped
                    expect(mappedItem).toNot(beNil())
                    
                    expect(mappedItem?.accountDetails.name).to(equal("Testing123 Big Saver"))
                    expect(mappedItem?.accountDetails.number).to(equal("062003 29299 9292"))
                    expect(mappedItem?.accountDetails.availableBalance).to(equal(10000.55))
                    expect(mappedItem?.accountDetails.currentBalance).to(equal(999.99))
                    
                    expect(mappedItem?.clearedTransactions.count).to(equal(4))
                    expect(mappedItem?.clearedTransactions.first?.identifier).to(equal("44e5b2bc484331ea24afd85ecfb212c8"))
                    expect(mappedItem?.clearedTransactions.first?.amount).to(equal(12))
                    expect(mappedItem?.clearedTransactions.first?.narrative).to(equal("Kaching TFR from JOHN CITIZEN<br/>xmas donation"))
                    expect(mappedItem?.clearedTransactions.first?.timestamp).to(equal(self.dateFromString("20/12/2019")))
                    expect(mappedItem?.clearedTransactions.first?.atmId).to(equal("129382"))
                    
                    expect(mappedItem?.pendingTransactions.count).to(equal(2))
                    expect(mappedItem?.pendingTransactions.first?.identifier).to(equal("e2eff6c2dafd909df8508f891b385d88"))
                    expect(mappedItem?.pendingTransactions.first?.amount).to(equal(-12.55))
                    expect(mappedItem?.pendingTransactions.first?.narrative).to(equal("WILSON PARKING SYDOBS SYDNEY NS AUS<br/>LAST 4 CARD DIGITS: 6901"))
                    expect(mappedItem?.pendingTransactions.first?.timestamp).to(equal(self.dateFromString("22/08/2020")))
                    expect(mappedItem?.pendingTransactions.first?.atmId).to(equal("137483"))
                    
                    expect(mappedItem?.atmLocations.count).to(equal(2))
                    expect(mappedItem?.atmLocations.first?.identifier).to(equal("129382"))
                    expect(mappedItem?.atmLocations.first?.name).to(equal("Circular Quay Station"))
                    expect(mappedItem?.atmLocations.first?.address).to(equal("8 Alfred St, Sydney, NSW 2000"))
                    expect(mappedItem?.atmLocations.first?.coordinate.latitude).to(equal(-33.86138199999999488))
                    expect(mappedItem?.atmLocations.first?.coordinate.longitude).to(equal(151.21031600000002048))
                }
            }
            
            context("incorrect JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "incorrect_account_data")
                }

                it("should not decode to valid `FullAccountDetailsResponse` object") {

                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(DateFormattingHelper.shortDate)
                    let mappedItem = try? jsonDecoder.decode(FullAccountDetailsResponse.self, from: testJSONData)

                    // due to incorrect JSON struture, it cannot be mapped to `FullAccountDetailsResponse` object
                    expect(mappedItem).to(beNil())
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func dateFromString(_ string: String) -> Date? {
        return DateFormattingHelper.shortDate.date(from: string)
    }
}

