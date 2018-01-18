//
//  Notification+Extension.swift
//  Swift-Useful-Files
//
//  Created by Husar Maksym on 2/14/17.
//  Copyright © 2017 Husar Maksym. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let InternetNotAvailable = Notification.Name("InternetNotAvailable")
    
    static let CategoriesLoaded = Notification.Name("CategoriesLoaded")
    static let DidFailLoadCategories = Notification.Name("DidFailLoadCategories")
    
    static let QuestionsLoaded = Notification.Name("QuestionsLoaded")
    static let DidFailLoadQuestions = Notification.Name("DidFailLoadQuestions")
}
