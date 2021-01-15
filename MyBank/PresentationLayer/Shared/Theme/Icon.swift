//
//  Icon.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 15/1/21.
//  Copyright © 2021 Arinjoy Biswas. All rights reserved.
//

import UIKit

extension Theme {
    
    enum Icon {
        
        case bankAccount
        case atmTransaction
        case atmFindUsPin
        
        var image: UIImage {
            switch self {
            case .bankAccount:
                return tintedImage(named: "piggybank-icon")
            case .atmTransaction:
                return tintedImage(named: "atm-transaction-icon")
            case .atmFindUsPin:
                return tintedImage(named: "atm-location-icon")
            }
        }
        
        
        // MARK: - Private helper
        
        private func tintedImage(named imageName: String, andColor color: UIColor = Theme.Color.sunflower) -> UIImage {
            guard let image = UIImage(named: imageName) else {
                fatalError("\(imageName) cannot be found is asset catalog!")
            }
            
            return image.withTintColor(color)
        }
    }
}
