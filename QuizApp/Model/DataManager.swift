//
//  DataManager.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/25/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import SwiftyJSON

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private(set) var categories: [Category] = []
    private var questions: [Int: [Question]] = [:]
    private let persistanceStorage: PersistanceService = CoreDataManager()
    
    func loadCategories() {
        if persistanceStorage.isCategoriesExist {
            persistanceStorage.fetchCategories { [unowned self] fetchedCategories in
                self.categories = fetchedCategories
                self.postMainQueueNotification(withName: .CategoriesLoaded)
            }
        } else {
            NetworkService.request(endpoint: QuizEndpoint.categories) { [unowned self] response in
                guard let value = response.value else {
                    self.postMainQueueNotification(withName: .DidFailLoadCategories)
                    return
                }
                let json = JSON(value)
                self.categories = []
                for item in json.arrayValue {
                    guard let category = Category(json: item) else { continue }
                    self.categories.append(category)
                }
                self.categories.sort { $0.name < $1.name }
                self.persistanceStorage.saveCategories(self.categories)
                self.postMainQueueNotification(withName: .CategoriesLoaded)
            }
        }
    }
    
    func questions(for category: Category) -> [Question]? {
        return questions[category.id]
    }
    
    func loadQuestions(for category: Category) {
        if persistanceStorage.isQuestionsExist(for: category) {
            persistanceStorage.fetchQuestions(for: category) { [unowned self] fetchedQuestions in
                self.questions[category.id] = fetchedQuestions
                self.postMainQueueNotification(withName: .QuestionsLoaded)
            }
        } else {
            NetworkService.request(endpoint: QuizEndpoint.questions(category: category))
            { [unowned self] response in
                guard let value = response.value else {
                    self.postMainQueueNotification(withName: .DidFailLoadQuestions)
                    return
                }
                let json = JSON(value)
                var questionsArray = [Question]()
                for item in json.arrayValue {
                    guard let question = Question(json: item) else { continue }
                    questionsArray.append(question)
                }
                self.questions[category.id] = questionsArray
                self.persistanceStorage.saveQuestions(questionsArray, for: category)
                self.postMainQueueNotification(withName: .QuestionsLoaded)
            }
        }
    }
    
    func clearLocalStorage() {
        persistanceStorage.deleteAllData()
    }
    
    // MARK: - Private methods
    private func postMainQueueNotification(withName name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
        if Thread.isMainThread {
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        } else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
            }
        }
    }
}
