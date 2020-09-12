//
//  AccountDetailsHeaderCell.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

class AccountDetailsHeaderCell: UITableViewCell, NibProvidable, ReusableView {
    
    static let approximateRowHeight: CGFloat = 200
    
    
    @IBOutlet weak var accountNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyles()
    }
    
    // MARK: - Configuration
    
    func configure(withPresentationItem item: AccountDetailsPresentationItem) {
        self.accountNameLabel.text = item.nickname
        
        // TODO: configure accessibility & pass in all other data
    }
    
    // MARK: - Private Helpers
    
    private func applyStyles() {
        contentView.backgroundColor = Theme.Color.sunflower
        accountNameLabel.font = Theme.Font.body
        accountNameLabel.numberOfLines = 1
    }
    
}
