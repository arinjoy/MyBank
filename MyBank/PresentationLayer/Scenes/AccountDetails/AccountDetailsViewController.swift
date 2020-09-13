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

    typealias DataSource = UITableViewDiffableDataSource<GroupedTransactionSection, TransactionPresentationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<GroupedTransactionSection, TransactionPresentationItem>
    
    private var dataSections: [GroupedTransactionSection] = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<GroupedTransactionSection, TransactionPresentationItem> = {
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
                    self?.updateTransactionList()
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
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = TransctionSectionHeaderView.approximateRowHeight
        tableView.separatorStyle = .none
        
        tableView.registerNib(cellClass: TransactionCell.self)
        
        let nib = UINib(nibName: "TransctionSectionHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: TransctionSectionHeaderView.reuseIdentifer)
        tableView.dataSource = dataSource
        tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAccountDetails), for: .valueChanged)
    }
    
    @objc
    private func refreshAccountDetails() {
        // TODO: presenter.load....
    }

    
    private func makeDataSource() -> UITableViewDiffableDataSource<GroupedTransactionSection, TransactionPresentationItem> {
        let dataSource = DataSource(
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
        return dataSource
    }
    
    private func updateTransactionList(animate: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections(dataSections)
        dataSections.forEach { section in
          snapshot.appendItems(section.transactionItems, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}


extension AccountDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TransctionSectionHeaderView.reuseIdentifer) as? TransctionSectionHeaderView
        else {
            return UITableViewHeaderFooterView()
        }
        headerView.configure(withPresentationItem: dataSections[section].headerItem)
        return headerView
    }
}
