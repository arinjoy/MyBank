//
//  AccountDetailsPresenting.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine

protocol AccountDetailsPresenting: class {

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
    // weak var display: AccountDetailsDisplay?
        
    // MARK: - Private Properties

    /// The retrieved data from the interactor
    private var accountDetailsWithTransactionData: AccountDetailsWithTransactionHistory?

    /// The interactor for finding all the details about account and its transaction history
    private let interactor: AccountDetailsInteracting!

    /// The data tranforming helper from domain lavel transaction models into their presentation items to show on the UI
    private let transactionListTransformer = TransactionListTransformer()
    
    private var cancellables: [AnyCancellable] = []
    
    
    // MARK: - Init
    
    init(interactor: AccountDetailsInteracting) {
        self.interactor = interactor
    }

    // MARK: - AccountDetailsPresenting
    
    var accountDetailsPresentationItem: AccountDetailsPresentationItem? {
        guard let data = accountDetailsWithTransactionData else { return nil }
        
        // TODO: Please do via a transformer
        return AccountDetailsPresentationItem(nickname: data.accountDetails.name,
                                              number: data.accountDetails.number,
                                              amount: "\(data.accountDetails.availableBalance)")
    }
    
    var transactionGroupsDataSource: [GroupedTransactionSection] {
        guard let data = accountDetailsWithTransactionData, !data.transactionsGroups.isEmpty else { return [] }
        return transactionListTransformer.transform(input: data.transactionsGroups)
    }
    
    func loadAccountDetailsAndTransactions(isRereshingNeeded: Bool) {
        
        guard isRereshingNeeded else { return }
        
        // Invalidate any old copy of the retrieved data as
        // this will be reset once interactor finds new data
        accountDetailsWithTransactionData = nil
        
        interactor
            .getAccountDetailsWithTransactionHistory()
            .sink(receiveValue: { [weak self] result in
                print(result)
                switch result {
                case .success(let response):
                    self?.accountDetailsWithTransactionData = response
                    // TODO: display?. handle UI update
                case .failure(let error):
                    print(error)
                    // TODO: handle custom error handling on UI via talking back to display
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Helpers
}
