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
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyles()
        atmIconImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        atmIconImageView.isHidden = true
    }
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: TransactionPresentationItem) {
        atmIconImageView.isHidden = !item.isAtmTransaction
        descriptionLabel.text = item.description
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
