//
//  AccountDetailsNetworkServiceSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
import Combine
@testable import MyBank

final class AccountDetailsNetworkServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Account Details Network Service Spec") {
            
            
            it("should call the load method on `NetworkService` with correct values being set") {
                
                let netwotkServiceSpy = NetworkServiceSpy()
                
                
                let _ = netwotkServiceSpy.load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
                
                // Spied call
                expect(netwotkServiceSpy.loadReourceCalled).to(beTrue())
                
                // Spied values
                expect(netwotkServiceSpy.isLocalStub).to(beFalse())
                
                expect(netwotkServiceSpy.url).toNot(beNil())
                expect(netwotkServiceSpy.url?.absoluteString).to(equal("<https://www.dropbox.com/s/tewg9b71x0wrou9/data.json"))
                
                expect(netwotkServiceSpy.parameters).toNot(beNil())
                expect(netwotkServiceSpy.parameters?.count).to(equal(1))
                expect(netwotkServiceSpy.parameters?.first?.key).to(equal("dl")) // URL query param `?dl=1` is added
                expect(netwotkServiceSpy.parameters?.first?.value.description).to(equal("1"))
                
                expect(netwotkServiceSpy.request).toNot(beNil())
            }
        }
    }
}
