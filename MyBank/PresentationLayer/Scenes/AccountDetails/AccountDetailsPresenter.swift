//
//  AccountDetailsPresenting.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol AccountDetailsPresenting: class {
    
    /// Will be called upon initial view load
    func viewDidBecomeReady()

    /// Will load the account details along with transactions history list
    ///
    /// - Parameter isRereshingNeeded: Whether data refreshing is needed
    func loadAccountDetailsAndTransactions(isRereshingNeeded: Bool)
    
    /// The UI level presentation item for the  account details header section
    var accountDetailsPresentationItem: AccountDetailsPresentationItem? { get }
    
    /// The transformed list data of transaction history ready to be bind with list UI
    var transactionGroupsDataSource: [GroupedTransactionSection] { get }
}

final class AccountDetailsPresenter: AccountDetailsPresenting {

    /// The front-facing view that conforms to the `AccountDetailsDisplay` protocol
    weak var display: AccountDetailsDisplay?
        
    
    // MARK: - Private Properties

    /// The retrieved data from the interactor
    private var accountDetailsWithTransactionData: AccountDetailsWithTransactionHistory?

    /// The interactor for finding all the details about the account and its transaction history
    private let interactor: AccountDetailsInteracting!

    /// The data tranforming helper from domain lavel transaction models into their presentation items to show on the UI
    private let transactionListTransformer = TransactionListTransformer()
    
    private var cancellables: [AnyCancellable] = []
    
    
    // MARK: - Init
    
    init(interactor: AccountDetailsInteracting) {
        self.interactor = interactor
    }

    // MARK: - AccountDetailsPresenting
    
    func viewDidBecomeReady() {
        display?.setTitle(StringKeys.MyBank.accountDetailsHeading.localized())
    }
    
    func loadAccountDetailsAndTransactions(isRereshingNeeded: Bool) {
        
        guard isRereshingNeeded else { return }
        
        display?.showLoadingIndicator()
        
        // Invalidate any old copy of the retrieved data as
        // this will be reset once interactor finds new data
        accountDetailsWithTransactionData = nil
        
        interactor
            .getAccountDetailsWithTransactionHistory()
            .sink(receiveValue: { [weak self] result in
                
                self?.display?.hideLoadingIndicator()
                
                switch result {
                case .success(let response):
                    
                    // Save the latest data
                    self?.accountDetailsWithTransactionData = response
                    
                    // Talk to display to update the UI
                    self?.display?.updateAccountDetailsHeader()
                    self?.display?.updateTransactionList()
                    
                case .failure(let error):
                    
                    let errorTitle: String = StringKeys.MyBank.genericErrorTitle.localized()
                    let errorDismissTitle: String = StringKeys.MyBank.errorDismissActionTitle.localized()
                    var errorMessage: String
                    switch error {
                        // Show network connectivity error
                    case .networkFailure, .timeout:
                        errorMessage = StringKeys.MyBank.networkConnectionErrorMessage.localized()
                    default:
                        // For all other errors, show this generic error
                        // This can be elaborated case by case basis of custom error handling
                        errorMessage = StringKeys.MyBank.genericErrorMessage.localized()
                    }
                    
                    self?.display?.showError(title: errorTitle,
                                            message: errorMessage,
                                            dismissTitle: errorDismissTitle)
                }
            })
            .store(in: &cancellables)
    }
    
    var accountDetailsPresentationItem: AccountDetailsPresentationItem? {
        guard let accountDetails = accountDetailsWithTransactionData?.accountDetails else { return nil }
        
        // TODO: Please do via a transformer
        return AccountDetailsPresentationItem(accountTypeIcon: UIImage(named: "accountsimagetransactional")!,
                                              accountDisplayName: accountDetails.name,
                                              accountNumber: accountDetails.number,
                                              availableBalanceText: NumberFormatterHelper.signedCurrency.string(from: accountDetails.availableBalance as NSNumber)!,
                                              currentBalanceText: NumberFormatterHelper.signedCurrency.string(from: accountDetails.currentBalance as NSNumber)!)
    }
    
    var transactionGroupsDataSource: [GroupedTransactionSection] {
        guard let data = accountDetailsWithTransactionData, !data.transactionsGroups.isEmpty else { return [] }
        return transactionListTransformer.transform(input: data.transactionsGroups)
    }
    
    // MARK: - Private Helpers
}
