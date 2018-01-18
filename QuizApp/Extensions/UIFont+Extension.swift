//
//  UIFont+Extension.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/18/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontFamily: String {
        case standard = "GillSans"
    }
    
    enum FontWeight: String {
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case bold = "Bold"
        case italic = "Italic"
    }
    
    class func font(ofSize size: CGFloat, weight: FontWeight = .italic, family: FontFamily = .standard) -> UIFont {
        let fontName = "\(family.rawValue)-\(weight.rawValue)"
        guard let selectedFont = UIFont(name: fontName, size: size) else {
            preconditionFailure("Error! Custom font doesn't found")
        }
        return selectedFont
    }
}
