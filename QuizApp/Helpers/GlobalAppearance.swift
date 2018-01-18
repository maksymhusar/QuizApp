//
//  GlobalAppearance.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/18/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

struct GlobalAppearance {
    
    static func configure() {
        configureNavigationBar()
        UIButton.appearance().isExclusiveTouch = true
    }
    
    // MARK: - Private methods
    private static func configureNavigationBar() {
        let attrs = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                      NSAttributedStringKey.foregroundColor : UIColor.white]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
    }
}

