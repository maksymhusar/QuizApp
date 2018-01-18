//
//  QuestionMO+CoreDataProperties.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/15/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//
//

import Foundation
import CoreData


extension QuestionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionMO> {
        return NSFetchRequest<QuestionMO>(entityName: "QuestionMO")
    }

    @NSManaged public var id: Int32
    @NSManaged public var text: String?
    @NSManaged public var answers: [String]?
    @NSManaged public var correctAnswerIndex: Int32
    @NSManaged public var category: CategoryMO?

}
