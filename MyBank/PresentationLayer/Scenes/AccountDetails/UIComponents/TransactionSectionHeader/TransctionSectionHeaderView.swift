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
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyStyles()
    }
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: TransctionSectionHeaderPresentationItem) {
        applyStyles()
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
    
    // MARK: - Private Helpers
    
    private func applyStyles() {
        titleLabel.font = Theme.Font.subheading
        titleLabel.textColor = Theme.Color.headerText
        subtitleLabel.font = Theme.Font.body
        subtitleLabel.textColor = Theme.Color.headerText
        contentView.backgroundColor = Theme.Color.sunflower
    }
}
