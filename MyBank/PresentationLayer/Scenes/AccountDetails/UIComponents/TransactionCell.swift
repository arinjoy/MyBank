//
//  TransactionCell.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

final class TransactionCell: UITableViewCell, NibProvidable, ReusableView {
    
    static let approximateRowHeight: CGFloat = 60

    // MARK: - Outlets
    
    @IBOutlet weak var atmIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    @IBOutlet weak var atmIconWidthConstraint: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyles()
        atmIconWidthConstraint.constant = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        atmIconWidthConstraint.constant = 0
    }
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: TransactionPresentationItem) {
        atmIconWidthConstraint.constant = item.isAtmTransaction ? 50 : 0
        descriptionLabel.attributedText = item.description
        amountLabel.text = item.amount
        
        // TODO: configure accessibility
    }
    
    // MARK: - Private Helpers
    
    private func applyStyles() {
        contentView.backgroundColor = Theme.Color.greyBackground
        descriptionLabel.font = Theme.Font.body
        descriptionLabel.numberOfLines = 0
        amountLabel.font = Theme.Font.subheading
        amountLabel.numberOfLines = 1
    }
}
