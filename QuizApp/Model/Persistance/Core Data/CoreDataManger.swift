//
//  CoreDataManger.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/15/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "QuizApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

extension CoreDataManager: PersistanceService {
    var isCategoriesExist: Bool {
        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        guard let categoriesCount = try? persistentContainer.viewContext.count(for: request) else {
            return false
        }
        return categoriesCount > 0
    }
    
    /// completionHandler called NOT in the main queue
    func fetchCategories(completionHandler: @escaping ([Category]) -> Void ) {
        persistentContainer.performBackgroundTask { bgContext in
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let nameDescriptor = NSSortDescriptor(key: #keyPath(CategoryMO.name), ascending: true)
            request.sortDescriptors = [nameDescriptor]
            let fetchedResult = (try? bgContext.fetch(request)) ?? []
            let result = fetchedResult.map { $0.convertedPlainObject() }
            completionHandler(result)
        }
    }
    
    func saveCategories(_ categories: [Category]) {
        persistentContainer.performBackgroundTask { bgContext in
            categories.forEach {
                let categoryMO = CategoryMO(context: bgContext)
                categoryMO.setup(from: $0)
            }
            try? bgContext.save()
        }
    }
    
    func isQuestionsExist(for category: Category) -> Bool {
        guard let fetchedCategory = fetchCategory(byID: category.id, in: persistentContainer.viewContext) else { return false }
        guard let questions = fetchedCategory.questions else { return false }
        return questions.count > 0
    }
    
    /// completionHandler called NOT in the main queue
    func fetchQuestions(for category: Category,
                        completionHandler: @escaping ([Question]) -> Void) {
        persistentContainer.performBackgroundTask { [unowned self] bgContext in
            let fetchedCategory = self.fetchCategory(byID: category.id, in: bgContext)
            guard let fetchedQuestion = fetchedCategory?.questions as? Set<QuestionMO> else {
                completionHandler([])
                return
            }
            let result = fetchedQuestion.map { $0.convertedPlainObject() }
            completionHandler(result)
        }
    }
    
    func saveQuestions(_ questions: [Question], for category: Category) {
        persistentContainer.performBackgroundTask { [unowned self] bgContext in
            let fetchedCategory = self.fetchCategory(byID: category.id, in: bgContext)
            questions.forEach {
                let questionMO = QuestionMO(context: bgContext)
                questionMO.setup(from: $0)
                
                questionMO.category = fetchedCategory
                fetchedCategory?.addToQuestions(questionMO)
            }
            try? bgContext.save()
        }
    }
    
    func deleteAllData() {
        persistentContainer.performBackgroundTask { bgContext in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: CategoryMO.fetchRequest())
            _ = try? bgContext.execute(deleteRequest)
            try? bgContext.save()
        }
    }
    
    // MARK: - Private methods
    private func fetchCategory(byID categoryID: Int,
                               in context: NSManagedObjectContext) -> CategoryMO? {
        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(CategoryMO.id)) == \(categoryID)")
        
        let fetchedCategories = try? context.fetch(request)
        return fetchedCategories?.first
    }
}
