//
//  ViewController.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import Combine

final class AccountDetailsViewController: UIViewController {
    
    // MARK: - Outlets & UI elements
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.Color.tint
        return refreshControl
    }()
    
    // MARK: - Private Properties
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, TransactionPresentationItem> = {
        return makeDataSource()
    }()
    
    private var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Account Details"

        view.backgroundColor = .yellow
        
        configureTableView()
        
        // TEST data loading works via network service
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        // TODO: Handle all of these via VIPER or MVVM logic.
        
        let networkService = ServicesProvider.defaultProvider().network

        let somePublisher = networkService
            .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .eraseToAnyPublisher()

        somePublisher
            .sink(receiveValue: { [weak self] result in
                print(result)
                switch result {
                case .success(let response):
                    self?.updateTransactionList(
                        withPresentationItems: response.clearedTransactions.map { TransactionPresentationItem($0) })
                default: break
                }
            })
            .store(in: &cancellables)
        
    }
    
    // MARK: - Private Helpers
    
    private func configureTableView() {
        tableView.backgroundColor = Theme.Color.tealBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = TransactionCell.approximateRowHeight
        tableView.separatorStyle = .none
        
        tableView.registerNib(cellClass: TransactionCell.self)
        tableView.dataSource = dataSource
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAccountDetails), for: .valueChanged)
    }
    
    @objc
    private func refreshAccountDetails() {
        // TODO: presenter.load....
    }
    
    enum Section: CaseIterable {
        case accountDetailsHeader
        case transactionList
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, TransactionPresentationItem> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withClass: TransactionCell.self) else {
                    assertionFailure("Failed to dequeue \(TransactionCell.self)!")
                    return UITableViewCell()
                }
                cell.configure(withPresentationItem: item)
                return cell
            }
        )
    }
    
    private func updateTransactionList(
        withPresentationItems presentationItems: [TransactionPresentationItem],
        animate: Bool = false
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TransactionPresentationItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(presentationItems, toSection: .transactionList)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

