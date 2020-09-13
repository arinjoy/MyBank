//
//  TransactionSectionHeaderView.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

final class TransctionSectionHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifer: String = String(describing: self)
    static let approximateRowHeight: CGFloat = 40

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: TransctionSectionHeaderPresentationItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
