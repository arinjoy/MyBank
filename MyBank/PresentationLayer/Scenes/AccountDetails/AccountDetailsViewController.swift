//
//  ViewController.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
//import Combine

final class AccountDetailsViewController: UIViewController, AccountDetailsDisplay {

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
    
//    private var dataSections: [GroupedTransactionSection] = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<GroupedTransactionSection, TransactionPresentationItem> = {
        return makeDataSource()
    }()
    
//    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Presenter
    
    /// The presenter conforming to the `AccountDetailsPresenting`
    private lazy var presenter: AccountDetailsPresenting = {
        
        /**
         Tech note:
         A chain of depdendency injection layer by layer, and each layer is individually unit tested
         Ideally this depdendency injection can be done via 3rd party library like `Swinject`
         */
        
        let presenter = AccountDetailsPresenter(
            interactor: AccoundDetailsInteractor(
                
                // TODO: change here to point from realNetworks vs. local Stub
                // Use `ServicesProvider.defaultProvider().network
                
                networkService: ServicesProvider.localStubbedProvider().network
            )
        )
        presenter.display = self
        return presenter
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        configureTableView()
        
        presenter.viewDidBecomeReady()
        
        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
    }
    
    // MARK: - AccountDetailsDisplay
    
    func setTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func updateAccountDetailsHeader() {
        // TODO: Attach data to the table view top big header
    }
    
    func updateTransactionList() {
        var snapshot = Snapshot()
        snapshot.appendSections(presenter.transactionGroupsDataSource)
        presenter.transactionGroupsDataSource.forEach { section in
          snapshot.appendItems(section.transactionItems, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showLoadingIndicator() {
        // TODO:
        refreshControl.isHidden = false
        refreshControl.beginRefreshing()
    }
    
    func hideLoadingIndicator() {
        // TODO:
        refreshControl.endRefreshing()
        refreshControl.isHidden = true
    }
    
    func showError(title: String, message: String, dismissTitle: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: dismissTitle, style: .cancel))
        present(alertController, animated: true, completion: nil)
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
        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
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
}

extension AccountDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard presenter.transactionGroupsDataSource.count > section,
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TransctionSectionHeaderView.reuseIdentifer) as? TransctionSectionHeaderView
        else {
            return UITableViewHeaderFooterView()
        }
        headerView.configure(withPresentationItem: presenter.transactionGroupsDataSource[section].headerItem)
        return headerView
    }
}
