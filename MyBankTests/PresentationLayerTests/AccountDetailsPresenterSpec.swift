//
//  AccountDetailsPresenterSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Quick
import Nimble
@testable import MyBank

final class AccountDetailsPresenterSpec: QuickSpec {

    override func spec() {
        
        describe("Account Details Presenter Spec") {
            
            var presenter: AccountDetailsPresenter!
            
            context("while communicating with interactor") {
                
                var interactorSpy: AccountDetailsInteractorSpy!
                var displayDummy: AccountDetailsDisplayDummy!
                
                it("should talk to interactor when being asked to load the details with refreshing needed") {
                    
                    // given
                    interactorSpy = AccountDetailsInteractorSpy()
                    presenter = AccountDetailsPresenter(interactor: interactorSpy)
                    displayDummy = AccountDetailsDisplayDummy()
                    presenter.display = displayDummy
                    
                    // when
                    presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                    
                    // then
                    expect(interactorSpy.getAccountDetailsWithTransactionHistoryCalled).toEventually(beTrue())
                }
            }
            
            context("communication back with display on interactor behaviour") {
                
                var interactorMock: AccountDetailsInteractorMock!
                var displaySpy: AccountDetailsDisplaySpy!
                
                beforeEach {
                    interactorMock = AccountDetailsInteractorMock()
                    presenter = AccountDetailsPresenter(interactor: interactorMock)
                    displaySpy = AccountDetailsDisplaySpy()
                    presenter.display = displaySpy
                }
                
                it("should set the navigation title on view load") {
                    
                    // when
                    presenter.viewDidBecomeReady()
                    
                    // then
                    expect(displaySpy.setTitleCalled).to(beTrue())
                    expect(displaySpy.title).to(equal("Account Details"))
                }
                
                it("should show loading indicator when deatails are being loaded with refreshing needed") {
                    
                    // when
                    presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                    
                    // then
                    expect(displaySpy.showLoadingIndicatorCalled).to(beTrue())
                }
                
                context("account details are loaded successfully") {
                                   
                    beforeEach {
                        interactorMock = AccountDetailsInteractorMock(returningError: false)
                        presenter = AccountDetailsPresenter(interactor: interactorMock)
                        presenter.display = displaySpy
                    }

                    it("should hide loading indicator eventually") {
                       // when
                       presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                       // then
                       expect(displaySpy.hideLoadingIndicatorCalled).toEventually(beTrue())
                    }
                    
                    it("should update the account details header eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.updateAccountDetailsHeaderCalled).toEventually(beTrue())
                        
                        expect(presenter.accountDetailsPresentationItem?.accountDisplayName)
                            .toEventually(equal("Testing123 Big Saver"))
                        expect(presenter.accountDetailsPresentationItem?.availableBalanceText)
                            .toEventually(equal("$10,000.55"))
                        // Transformation specs are done individually already in `AccountDetailTransformerSpec`,
                        // so no point of re-testing all here again
                    }
                    
                    it("should update the transaction list eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.updateTransactionListCalled).toEventually(beTrue())
                        
                        expect(presenter.transactionGroupsDataSource.count).toEventually(equal(2))
                        expect(presenter.transactionGroupsDataSource.first?.headerItem.title)
                            .toEventually(equal("20 Feb 2020"))
                        expect(presenter.transactionGroupsDataSource.first?.transactionItems.count).toEventually(equal(2))
                        expect(presenter.transactionGroupsDataSource.first?.transactionItems.first?.description.string).toEventually(equal("PENDING: A long description"))
                        expect(presenter.transactionGroupsDataSource.first?.transactionItems.first?.amountText).toEventually(equal("-$5,555.44"))
                        // Transformation specs are done individually already in `TransactionListTransformerSpec`,
                        // so no point of re-testing all here again
                    }
                }
                
                context("account details are not loaded successfully due to some server error") {
                                   
                    beforeEach {
                        interactorMock = AccountDetailsInteractorMock(returningError: true,
                                                                      error: NetworkError.server)
                        presenter = AccountDetailsPresenter(interactor: interactorMock)
                        presenter.display = displaySpy
                    }

                    it("should hide loading indicator eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.hideLoadingIndicatorCalled).toEventually(beTrue())
                    }
                    
                    it("should show an error with correct copies eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.showErrorCalled).toEventually(beTrue())
                        expect(displaySpy.errorTitle).toEventually(equal("Oops! Something wrong."))
                        expect(displaySpy.errorMessage).toEventually(equal("There is a generic error. Please try again later."))
                        expect(displaySpy.errorDismissTitle).toEventually(equal("OK"))
                    }
                }
                
                context("account details are not loaded successfully due to network connectivity/timeout error") {
                                   
                    beforeEach {
                        interactorMock = AccountDetailsInteractorMock(returningError: true,
                                                                      error: NetworkError.networkFailure)
                        presenter = AccountDetailsPresenter(interactor: interactorMock)
                        presenter.display = displaySpy
                    }

                    it("should hide loading indicator eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.hideLoadingIndicatorCalled).toEventually(beTrue())
                    }
                    
                    it("should show an error correct copies eventually") {
                        // when
                        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                       
                        // then
                        expect(displaySpy.showErrorCalled).toEventually(beTrue())
                        expect(displaySpy.errorTitle).toEventually(equal("You're offline!"))
                        expect(displaySpy.errorMessage).toEventually(equal("Please check your network connection and try again."))
                        expect(displaySpy.errorDismissTitle).toEventually(equal("OK"))
                    }
                }
            }
            
            context("user interaction behaviour and routing navigation logic") {
                
                var interactorMock: AccountDetailsInteractorMock!
                var displayDummy: AccountDetailsDisplayDummy!
                var routerSpy: AccountDetailsRouterSpy!
                
                beforeEach {
                    interactorMock = AccountDetailsInteractorMock(returningError: false)
                    presenter = AccountDetailsPresenter(interactor: interactorMock)
                    displayDummy = AccountDetailsDisplayDummy()
                    routerSpy = AccountDetailsRouterSpy()
                    presenter.display = displayDummy
                    presenter.router = routerSpy
                }
                
                it("should not navigate to ATM map view unless the cell is tappable with atm location in it") {
                    // when
                    presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                    presenter.didTapTransaction(at: IndexPath(row: 0, section: 0)) // non-atm transaction at this cell
                    
                    // then
                    expect(routerSpy.routeToAtmLocationMapCalled).toEventually(beFalse())
                }
                
                fit("should navigate to ATM map view when an ATM transaction has been mapped") {

                    // when
                    presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
                    presenter.didTapTransaction(at: IndexPath(row: 1, section: 0)) // atm transaction at this cell
                    
                    // then
                    expect(routerSpy.routeToAtmLocationMapCalled).toEventually(beTrue())
                    
                    // make sure correct atm information was passed in as view model
                    expect(routerSpy.atmMapViewModel).toEventuallyNot(beNil())
                    expect(routerSpy.atmMapViewModel?.viewTitle).toEventually(equal("ATM Location"))
                    expect(routerSpy.atmMapViewModel?.atmLocation.name)
                        .toEventually(equal("Circular Quay Station"))
                    expect(routerSpy.atmMapViewModel?.atmLocation.address)
                        .toEventually(equal("8 Alfred St, Sydney, NSW 2000"))
                    expect(routerSpy.atmMapViewModel?.atmLocation.coordinate.latitude)
                        .toEventually(equal(-33.8613819999999948))
                    expect(routerSpy.atmMapViewModel?.atmLocation.coordinate.longitude)
                        .toEventually(equal(151.21031600000002048))
                    expect(routerSpy.atmMapViewModel?.customPinImage)
                        .toEventually(equal(Theme.Icon.atmFindUsPin.image))
                }
            }
        }
    }
}
