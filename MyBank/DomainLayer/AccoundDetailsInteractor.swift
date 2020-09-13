//
//  AccoundDetailsInteractor.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine

protocol AccountDetailsInteracting: class {
    
    /// Get everything at once - account details + transaction history
    /// Not ideal. As they are fetched separately from different APIs in relaity. But for simplicity they are fetched teogther within one network call
    func getAccountDetailsWithTransactionHistory() -> AnyPublisher<Result<AccountDetailsWithTransactionHistory, NetworkError>, Never>
}


final class AccoundDetailsInteractor: AccountDetailsInteracting {

    // MARK: - Depdendency
    
    private let networkService: NetworkServiceType

    // MARK: - Init
    
    init(networkService: NetworkServiceType = ServicesProvider.defaultProvider().network) {
        self.networkService = networkService
    }
    
    // MARK: - AccoundDetailsInteracting
    
    func getAccountDetailsWithTransactionHistory() -> AnyPublisher<Result<AccountDetailsWithTransactionHistory, NetworkError>, Never> {
        return networkService
        .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
        .map({ (result: Result<FullAccountDetailsResponse, NetworkError>) -> Result<AccountDetailsWithTransactionHistory, NetworkError> in
            switch result {
            case .success(let resonse):
                let transactionGroups = self.computeTransactionGroups(fromClearedTransactions: resonse.clearedTransactions,
                                                                      andPendingTransactions: resonse.pendingTransactions,
                                                                      atmLocations: resonse.atmLocations)
                let accountDetailsWithTransactionHistory = AccountDetailsWithTransactionHistory(
                    accountDetails: resonse.accountDetails,
                    transactionsGroups: transactionGroups)
                return .success(accountDetailsWithTransactionHistory)
            case .failure(let error):
                return .failure(error)
            }
        })
        .subscribe(on: Scheduler.background)
        .receive(on: Scheduler.main)
        .eraseToAnyPublisher()
    }

    // MARK: - Private
    
    private func computeTransactionGroups(
        fromClearedTransactions clearedTransactions: [Transaction],
        andPendingTransactions pendingTransactions: [Transaction],
        atmLocations: [ATMLocation]
    ) -> [TransactionGroup] {
        
        let allDates = (clearedTransactions + pendingTransactions).map { $0.timestamp }
        let uniqueDates = Array(Set(allDates)).sorted { $0.compare($1) == .orderedDescending }
        
        var groups: [TransactionGroup] = []
        
        for date in uniqueDates {
            let pendingTrans = pendingTransactions
                .filter { $0.timestamp == date }
                .map {
                    transactionDomainModel(fromDataModel: $0, isPending: true, atmLocations: atmLocations)
                 }
            let clearedTrans = clearedTransactions
                .filter { $0.timestamp == date }
                .map {
                    transactionDomainModel(fromDataModel: $0, isPending: false, atmLocations: atmLocations)
                 }
            let allTransForTheDate = (pendingTrans + clearedTrans)
                .sorted { $0.processingDate.compare($1.processingDate) == .orderedDescending }
            groups.append(TransactionGroup(date: date, transactions: allTransForTheDate))
        }
        return groups
    }
    
    private func transactionDomainModel(fromDataModel transaction: Transaction,
                                        isPending: Bool,
                                        atmLocations: [ATMLocation]) -> TransactionModel {
        
        // Here is some sort of business logic...
        // - Text sanitisation
        // - Atm object injection (Not a good idea to do this in prodcution, but for simple/demo app doing this way)
        // In reality there could be many more business logic to apply on the raw data JSON data level objects
        // and transform into domain level objects
        
        let sanitizedDescription = transaction.narrative
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "<br/>", with: "/n")
        
        let atmLocation = atmLocations.filter { $0.identifier == transaction.atmId }.first
        
        return TransactionModel(id: transaction.identifier,
                                processingDate: transaction.timestamp,
                                narrativeText: sanitizedDescription,
                                amount: transaction.amount,
                                isPending: isPending,
                                atmLocation: atmLocation)
    }
}
