//
//  Theme.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

struct Theme {
    
    // MARK: - Colors
    
    struct Color {
          
        static let primaryText = UIColor(light: UIColor.colorFrom(red: 35, green: 31, blue: 32),
                                         dark: UIColor.white.withAlphaComponent(0.9))
        static let secondaryText = UIColor(light: UIColor.colorFrom(red: 138, green: 138, blue: 138),
                                           dark: UIColor.white.withAlphaComponent(0.6))
        static let headerText = UIColor.colorFrom(red: 35, green: 31, blue: 32)

        static let leafyGreen = UIColor.colorFrom(red: 46, green: 175, blue: 70)
        static let lightGreen = UIColor.colorFrom(red: 141, green: 215, blue: 156)
        
        static let tealBackground = UIColor.colorFrom(red: 135, green: 158, blue: 126)
        static let greyBackground =  UIColor(light: UIColor.colorFrom(red: 246, green: 246, blue: 246),
                                             dark: UIColor.systemGray4)
        
        // TODO: possibly tweak this for dark mode
        static let tint = UIColor(light: Theme.Color.leafyGreen, dark: Theme.Color.leafyGreen)
        static let background =  UIColor(light: UIColor.white, dark: UIColor.black)
    }

    // MARK: - Fonts
    
    struct Font {
        
        /// Making it 22pt to make it look bigger. 18pt might be a bit small, compared to rest below which are 16pt
        static let title: UIFont = {
            let titleFont = UIFont(name: "AvenirNext-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .light)
            return UIFontMetrics(forTextStyle: .title1).scaledFont(for: titleFont)
        }()
        
        static let subheading: UIFont = {
            let titleFont = UIFont(name: "AvenirNext-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
            return UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: titleFont)
        }()
        
        static let body: UIFont = {
            let titleFont = UIFont(name: "AvenirNext-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)
        }()
        
        static let footnote: UIFont = {
            let titleFont = UIFont(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
            return UIFontMetrics(forTextStyle: .footnote).scaledFont(for: titleFont)
        }()
    }
}

private extension UIColor {
    
    static func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }

    /// Creates a color object that generates its color data dynamically using the specified colors. For early SDKs creates light color.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}
