//
//  CategoryMO+CoreDataProperties.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/15/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "CategoryMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension CategoryMO {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuestionMO)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuestionMO)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
