//
//  AccountDetailsInteractorSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import MyBank

final class AccountDetailsInteractorSpec: QuickSpec {
    
    var accountDetailsWithTransactions: AccountDetailsWithTransactionHistory!
    var error: NetworkError!
    
    override func spec() {
        
        var interactor: AccountDetailsInteractor!
        var cancellables: [AnyCancellable] = []

        describe("AccountDetails Interactor Spec") {
            
            beforeEach {
                self.accountDetailsWithTransactions = nil
                self.error = nil
            }
            
            context("Get account details along with transaction history") {
                
                it("should call network service correctly") {
                    
                    // given
                    let serviceSpy = NetworkServiceSpy()
                    interactor = AccountDetailsInteractor(networkService: serviceSpy)
                    
                    // when
                    _ = interactor.getAccountDetailsWithTransactionHistory()
                    
                    // then
                    expect(serviceSpy.loadReourceCalled).toEventually(beTrue())
                }
                
                context("network service failed") {
                    
                    it("should return the error correctly for any error") {
                        
                        // given
                        let serviceMock = NetworkServiceMock(response: TestHelper().sampleAccountDetailsFullResponse(),
                                                             returningError: true, // fails
                                                             error: NetworkError.unAuthorized)
                        interactor = AccountDetailsInteractor(networkService: serviceMock)
                        
                        // when
                        interactor
                            .getAccountDetailsWithTransactionHistory()
                            .sink(receiveValue: { result in
                                switch result {
                                case .success(let response):
                                    self.accountDetailsWithTransactions = response
                                case .failure(let error):
                                    self.error = error
                                }
                             })
                            .store(in: &cancellables)
                    
                        // then
                        expect(self.accountDetailsWithTransactions).toEventually(beNil())
                        expect(self.error).toEventuallyNot(beNil())
                    }
                }
                
                context("network service succeeded") {
                    
                    it("should process the low level data response correctly and apply transaction grouping business logic") {
                        
                        // given
                        let serviceMock = NetworkServiceMock(response: TestHelper().sampleAccountDetailsFullResponse(),
                                                             returningError: false) // succeeds
                        interactor = AccountDetailsInteractor(networkService: serviceMock)
                        
                        // when
                        interactor
                            .getAccountDetailsWithTransactionHistory()
                            .sink(receiveValue: { result in
                                switch result {
                                case .success(let response):
                                    self.accountDetailsWithTransactions = response
                                case .failure(let error):
                                    self.error = error
                                }
                             })
                            .store(in: &cancellables)
                    
                        // then
                        expect(self.error).toEventually(beNil())
                        expect(self.accountDetailsWithTransactions).toEventuallyNot(beNil())
                        
                        expect(self.accountDetailsWithTransactions.accountDetails.name).toEventually(equal("Testing123 Big Saver"))
                        expect(self.accountDetailsWithTransactions.accountDetails.number).toEventually(equal("062003 29299 9292"))
                        expect(self.accountDetailsWithTransactions.accountDetails.availableBalance).toEventually(equal(10000.55))
                        
                        // Total 4 groups computed based 4 possible unique dates in test data
                        expect(self.accountDetailsWithTransactions.transactionsGroups.count).toEventually(equal(4))
                        let transactionsGroups = self.accountDetailsWithTransactions.transactionsGroups
                        
                        // The transaction groups are ordered based on decendeing order of dates
                        expect(transactionsGroups[0].date).toEventually(equal(TestHelper.dateFromString("22/08/2020")))
                        expect(transactionsGroups[0].transactions.count).toEventually(equal(1))
                        // Pending transaction
                        expect(transactionsGroups[0].transactions.first?.isPending).toEventually(beTrue())
                        expect(transactionsGroups[0].transactions.first?.processingDate)
                            .toEventually(equal(TestHelper.dateFromString("22/08/2020")))
                        // html <br/> is replaced with \n inside description (as sanitisation task)
                        expect(transactionsGroups[0].transactions.first?.narrativeText)
                            .toEventually(equal("WILSON PARKING SYDOBS SYDNEY NS AUS\nLAST 4 CARD DIGITS: 6901"))
                        // The atm location model has been injected
                        expect(transactionsGroups[0].transactions.first?.atmLocation).toEventuallyNot(beNil())
                        expect(transactionsGroups[0].transactions.first?.atmLocation?.identifier)
                            .toEventually(equal("137483"))
                        expect(transactionsGroups[0].transactions.first?.atmLocation?.name)
                            .toEventually(equal("Town Hall Square"))
                        expect(transactionsGroups[0].transactions.first?.atmLocation?.address)
                            .toEventually(equal("464-480 Kent St, Sydney, NSW 2000"))
                        expect(transactionsGroups[0].transactions.first?.atmLocation?.coordinate.latitude)
                            .toEventually(equal(-33.873181))
                        expect(transactionsGroups[0].transactions.first?.atmLocation?.coordinate.longitude)
                            .toEventually(equal(151.20538900000002048))
                        
                        expect(transactionsGroups[1].date).toEventually(equal(TestHelper.dateFromString("20/12/2019")))
                        expect(transactionsGroups[1].transactions.count).toEventually(equal(1))
                        // Cleared transaction
                        expect(transactionsGroups[1].transactions.first?.isPending).toEventually(beFalse())
                        expect(transactionsGroups[1].transactions.first?.processingDate)
                            .toEventually(equal(TestHelper.dateFromString("20/12/2019")))
                        // This one also ATM transaction, hence nil
                        expect(transactionsGroups[1].transactions.first?.atmLocation).toEventuallyNot(beNil())
                        
                        expect(transactionsGroups[2].date).toEventually(equal(TestHelper.dateFromString("21/11/2016")))
                        expect(transactionsGroups[2].transactions.count).toEventually(equal(3))
                        // Not an ATM transaction
                        expect(transactionsGroups[2].transactions.first?.atmLocation).toEventually(beNil())
                        
                        expect(transactionsGroups[3].date).toEventually(equal(TestHelper.dateFromString("03/11/2015")))
                        expect(transactionsGroups[3].transactions.count).toEventually(equal(1))
                    }
                }
            }
        }
    }
}

