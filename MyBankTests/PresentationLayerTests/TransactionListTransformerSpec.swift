//
//  TransactionListTransformerSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit.UIImage
import Quick
import Nimble
@testable import MyBank

final class TransactionListTransformerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Transaction List Transformer Spec") {
            
            var trasformer: TransactionListTransformer!
            var results: [GroupedTransactionSectionPresentationItem]!
            
            beforeEach {
                trasformer = TransactionListTransformer()
                results = trasformer.transform(input: TestHelper.sampleTransactionGroups())
            }
            
            it("should tranform the transaction list groups data items correctly into their presentation items") {
                
                // 2 groups/sections found
                expect(results.count).to(equal(2))
                
                let section1 = results.first
                expect(section1?.headerItem.title).to(equal("20 Feb 2020"))
                // Note: this below test is current system date dependent, hence will fail in future months
                // expect(section1?.headerItem.subtitle).to(equal("7 months ago"))
                expect(section1?.headerItem.accessibility?.identifier)
                    .to(equal("accessibilityId.account.details.transaction.section.header"))
                expect(section1?.headerItem.accessibility?.label).to(equal("20 Feb 2020, 7 months ago"))
                expect(section1?.headerItem.accessibility?.traits).to(equal(.header))
                
                // 2 transactions in first group
                expect(section1?.transactionItems.count).to(equal(2))
                
                // Not an atm transaction the first one
                expect(section1?.transactionItems.first?.atmIcon).to(beNil())
                // It's pending transaction, description has it injected
                expect(section1?.transactionItems.first?.description.string).to(equal("PENDING: A long description"))
                expect(section1?.transactionItems.first?.amountText).to(equal("-$5,555.44"))
                
                expect(section1?.transactionItems.first?.accessibility?.identifier)
                    .to(equal("accessibilityId.account.details.transaction.cell"))
                expect(section1?.transactionItems.first?.accessibility?.label)
                    .to(equal("Pending transaction, A long description, amount -$5,555.44"))
                expect(section1?.transactionItems.first?.accessibility?.traits).to(equal(.staticText))
 
                // Second one is an atm transaction, hence icon is `not nil`
                expect(section1?.transactionItems.last?.atmIcon).to(equal(UIImage(named: "FindUsIcon")!))
                // It's not pending, no keyword injected
                expect(section1?.transactionItems.last?.description.string).to(equal("A short description is enough"))
                expect(section1?.transactionItems.last?.amountText).to(equal("$120.23"))
                
                expect(section1?.transactionItems.last?.accessibility?.identifier)
                    .to(equal("accessibilityId.account.details.transaction.cell"))
                expect(section1?.transactionItems.last?.accessibility?.label)
                    .to(equal("Cleared transaction, A short description is enough, amount $120.23"))
                // Accessbility trait is correct as its tappable cell with atm transaction
                expect(section1?.transactionItems.last?.accessibility?.traits).to(equal(.button))
                expect(section1?.transactionItems.last?.accessibility?.hint)
                    .to(equal("Double click to see the ATM location on map"))
                
                let section2 = results.last
                expect(section2?.headerItem.title).to(equal("12 Jun 2019"))
                // Note: this below test is current system date dependent, hence will fail in future years
                // expect(section2?.headerItem.subtitle).to(equal("1 year ago"))
                expect(section2?.headerItem.accessibility?.identifier)
                    .to(equal("accessibilityId.account.details.transaction.section.header"))
                expect(section2?.headerItem.accessibility?.label).to(equal("12 Jun 2019, 1 year ago"))
                expect(section2?.headerItem.accessibility?.traits).to(equal(.header))
                
                // 1 transaction in last group
                expect(section2?.transactionItems.count).to(equal(1))
                expect(section2?.transactionItems.first?.atmIcon).to(beNil())
                // It's pending transaction, description has it injected
                expect(section2?.transactionItems.first?.description.string)
                    .to(equal("PENDING: A long description with NPP 🚗🚌🚎"))
                expect(section2?.transactionItems.first?.amountText).to(equal("$12,244.23"))
                
            }
        }
    }
}
