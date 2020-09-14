//
//  AccountDetailsPresenter+TestDoubles.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine
@testable import MyBank

// MARK: - Dislay Dummy

final class AccountDetailsDisplayDummy: AccountDetailsDisplay {
    func setTitle(_ title: String) {}
    func updateAccountDetailsHeader() {}
    func updateTransactionList() {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showError(title: String, message: String, dismissTitle: String) {}
}

// MARK: - Dislay Spy

final class AccountDetailsDisplaySpy: AccountDetailsDisplay {
    
    // Spied calls
    var setTitleCalled: Bool = false
    var updateAccountDetailsHeaderCalled = false
    var updateTransactionListCalled: Bool = false
    var showLoadingIndicatorCalled: Bool = false
    var hideLoadingIndicatorCalled: Bool = false
    var showErrorCalled: Bool = false
    
    // Spied values
    var title: String?
    var errorTitle: String?
    var errorMessage: String?
    var errorDismissTitle: String?
    
    
    func setTitle(_ title: String) {
        setTitleCalled = true
        self.title = title
    }
    
    func updateAccountDetailsHeader() {
        updateAccountDetailsHeaderCalled = true
    }
    
    func updateTransactionList() {
        updateTransactionListCalled = true
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showError(title: String, message: String, dismissTitle: String) {
        showErrorCalled = true
        errorTitle = title
        errorMessage = message
        errorDismissTitle = dismissTitle
    }
}

// MARK: - Presenter Dummy

final class AccountDetailsPresenterDummy: AccountDetailsPresenting {
    func viewDidBecomeReady() {}
    func loadAccountDetailsAndTransactions(isRereshingNeeded: Bool) {}
    var accountDetailsPresentationItem: AccountDetailsPresentationItem? { return nil }
    var transactionGroupsDataSource: [GroupedTransactionSectionPresentationItem] { return [] }
    func didTapTransaction(at indexPath: IndexPath) {}
}

// MARK: - Presenter Spy

final class AccountDetailsPresenterSpy: AccountDetailsPresenting {
    var viewDidBecomeReadyCalled: Bool = false
    var loadAccountDetailsAndTransactionsCalled: Bool =  false
    var didTapTransactionCalled: Bool = false
    
    func viewDidBecomeReady() {
        viewDidBecomeReadyCalled = true
    }
    
    func loadAccountDetailsAndTransactions(isRereshingNeeded: Bool) {
        loadAccountDetailsAndTransactionsCalled = true
    }
    
    var accountDetailsPresentationItem: AccountDetailsPresentationItem? { return nil }
    var transactionGroupsDataSource: [GroupedTransactionSectionPresentationItem] { return [] }
    
    func didTapTransaction(at indexPath: IndexPath) {
        didTapTransactionCalled = true
    }
}

// MARK: - Interactor Dummy

final class AccountDetailsInteractorDummy: AccountDetailsInteracting {
    
    func getAccountDetailsWithTransactionHistory() -> AnyPublisher<Result<AccountDetailsWithTransactionHistory, NetworkError>, Never> {
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Interactor Spy

final class AccountDetailsInteractorSpy: AccountDetailsInteracting {
    
    // Spied calls
    var getAccountDetailsWithTransactionHistoryCalled: Bool = false
    
    func getAccountDetailsWithTransactionHistory() -> AnyPublisher<Result<AccountDetailsWithTransactionHistory, NetworkError>, Never> {
        getAccountDetailsWithTransactionHistoryCalled = true
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Interactor Mock

final class AccountDetailsInteractorMock: AccountDetailsInteracting {
    
    var returningError: Bool
    var error: NetworkError
    var resultingData: AccountDetailsWithTransactionHistory
    
    init(
        returningError: Bool = false,
        error: NetworkError = NetworkError.unknown,
        resultingData: AccountDetailsWithTransactionHistory = TestHelper().sampleAccountDetailsWithTransactionHistory()
    ) {
        self.returningError = returningError
        self.error = error
        self.resultingData = resultingData
    }
    
    func getAccountDetailsWithTransactionHistory() -> AnyPublisher<Result<AccountDetailsWithTransactionHistory, NetworkError>, Never> {
        if returningError {
            return Just(.failure(error)).eraseToAnyPublisher()
        }
        return Just(.success(resultingData)).eraseToAnyPublisher()
    }
}
