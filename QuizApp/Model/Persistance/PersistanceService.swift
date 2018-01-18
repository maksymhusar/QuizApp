//
//  PersistanceService.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/18/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation

protocol PersistanceService {
    var isCategoriesExist: Bool { get }
    func fetchCategories(completionHandler: @escaping ([Category]) -> Void )
    func saveCategories(_ categories: [Category])
    
    func isQuestionsExist(for category: Category) -> Bool
    func fetchQuestions(for category: Category, completionHandler: @escaping ([Question]) -> Void)
    func saveQuestions(_ questions: [Question], for category: Category)
    
    func deleteAllData()
}
