//
//  File.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

class AccountDetailsHeaderView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var accountTypeIconView: UIImageView!
    @IBOutlet private weak var accountNameLabel: UILabel!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var separatorLineView: UIView!
    
    @IBOutlet private weak var bottomContainerView: UIView!
    @IBOutlet private weak var fundTitleLabel: UILabel!
    @IBOutlet private weak var fundAmountLabel: UILabel!

    @IBOutlet private weak var balanceTitleLabel: UILabel!
    @IBOutlet private weak var balanceAmountLabel: UILabel!

    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    private func initSubviews() {
        let nib = UINib(nibName: "AccountDetailsHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        applyStyles()
    }
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: AccountDetailsPresentationItem) {
        accountTypeIconView.image = item.accountTypeIcon
        accountNameLabel.text = item.accountDisplayName
        accountNumberLabel.text = item.accountNumber
        fundTitleLabel.text = item.availableBalanceLabel
        fundAmountLabel.text = item.availableBalanceText
        balanceTitleLabel.text = item.currentBalanceLabel
        balanceAmountLabel.text = item.currentBalanceText
        
        item.accessibility?.apply(to: self)
    }
    
    // MARK: - Private Helpers
    
    private func applyStyles() {
        contentView.backgroundColor = Theme.Color.tealBackground
        bottomContainerView.backgroundColor = Theme.Color.greyBackground
        separatorLineView.backgroundColor = Theme.Color.tealBackground.withAlphaComponent(0.3)
        
        accountNameLabel.font = Theme.Font.title
        accountNameLabel.textColor = Theme.Color.primaryText
        
        for label in [accountNumberLabel, fundTitleLabel, balanceTitleLabel] {
            label?.font = Theme.Font.body
            label?.textColor = Theme.Color.secondaryText
        }
        
        fundAmountLabel.font = Theme.Font.subheading
        fundAmountLabel.textColor = Theme.Color.primaryText
        
        balanceAmountLabel.font = Theme.Font.subheading
        balanceAmountLabel.textColor = Theme.Color.secondaryText
        
        isAccessibilityElement = true
    }
}
