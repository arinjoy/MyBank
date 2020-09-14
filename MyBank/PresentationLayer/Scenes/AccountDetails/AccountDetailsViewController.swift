//
//  ViewController.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

final class AccountDetailsViewController: UIViewController, AccountDetailsDisplay {

    // MARK: - Outlets & UI elements
    
    @IBOutlet weak var tableView: UITableView!
    
    private let accountDetailsHeaderView = AccountDetailsHeaderView(frame: CGRect())
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = Theme.Color.tealBackground
        refreshControl.tintColor = Theme.Color.primaryText
        return refreshControl
    }()
    
    // MARK: - Private Properties

    typealias DataSource = UITableViewDiffableDataSource<GroupedTransactionSectionPresentationItem, TransactionPresentationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<GroupedTransactionSectionPresentationItem, TransactionPresentationItem>
    
    private lazy var dataSource: UITableViewDiffableDataSource<GroupedTransactionSectionPresentationItem, TransactionPresentationItem> = {
        return makeDataSource()
    }()
    
    // MARK: - Presenter
    
    /// The presenter conforming to the `AccountDetailsPresenting`
    private lazy var presenter: AccountDetailsPresenting = {
        
        /**
         Tech note: A chain of depdendency injection layer by layer, and each layer is individually unit tested.
         Ideally this depdendency injection can be done via 3rd party library like `Swinject`.
         */
        
        let presenter = AccountDetailsPresenter(
            interactor: AccoundDetailsInteractor(
                // TODO: change here to point from real Network vs. local Stub
                // Use `ServicesProvider.defaultProvider().network for the prod app.
                networkService: ServicesProvider.localStubbedProvider().network
            )
        )
        presenter.display = self
        presenter.router = AccountDetailsRouter(sourceViewController: self)
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
        navigationItem.title = title
    }
    
    func updateAccountDetailsHeader() {
        // TODO: Handle self sizing correctly
        guard let item = presenter.accountDetailsPresentationItem else { return }
        
        accountDetailsHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
        accountDetailsHeaderView.configure(withPresentationItem: item)
        
        tableView.tableHeaderView = accountDetailsHeaderView
        tableView.tableHeaderView?.layoutSubviews()
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
        refreshControl.isHidden = false
        refreshControl.beginRefreshing()
        
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: "Refreshing account details")
        }
    }
    
    func hideLoadingIndicator() {
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
        tableView.separatorStyle = .singleLine
        
        tableView.registerNib(cellClass: TransactionCell.self)
        
        let nib = UINib(nibName: "TransctionSectionHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: TransctionSectionHeaderView.reuseIdentifer)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAccountDetails), for: .valueChanged)
    
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }
    
    @objc
    private func refreshAccountDetails() {
        presenter.loadAccountDetailsAndTransactions(isRereshingNeeded: true)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<GroupedTransactionSectionPresentationItem, TransactionPresentationItem> {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Just tell the presenter to take any responisbility which would make the correct
        // decision and logic and act via the router
        presenter.didTapTransaction(at: indexPath)
    }
}
