//
//  AccountDetailsTransformerSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit.UIImage
import Quick
import Nimble
@testable import MyBank

final class AccountDetailsTransformerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Account Details Transformer Spec") {
            
            var trasformer: AccountDetailsTransformer!
            var result: AccountDetailsPresentationItem!
            
            beforeEach {
                trasformer = AccountDetailsTransformer()
                result = trasformer.transform(input: TestHelper().sampleAccountDetailsFullResponse().accountDetails)
            }
            
            it("should tranform raw data item correctly into its correct presentation item") {
        
                expect(result).toNot(beNil())
                
                // Icon type is correct, based on business logic different icons can be for different account types
                expect(result.accountTypeIcon).to(equal(UIImage(named: "accountsimagetransactional")!))

                expect(result.accountDisplayName).to(equal("Testing123 Big Saver"))
                expect(result.accountNumber).to(equal("062003 29299 9292"))
                expect(result.availableBalanceLabel).to(equal("Available funds"))
                expect(result.availableBalanceText).to(equal("$10,000.55"))
                expect(result.currentBalanceLabel).to(equal("Account balance"))
                expect(result.currentBalanceText).to(equal("$999.99"))
                
                expect(result.accessibility?.identifier)
                    .to(equal("accessibilityId.account.details.header"))
                expect(result.accessibility?.label)
                    .to(equal("Account Testing123 Big Saver, Account number 062003 29299 9292, with Available funds $10,000.55, and Account balance $999.99"))
                expect(result.accessibility?.traits).to(equal(.header))
                     
            }
        }
    }
}
