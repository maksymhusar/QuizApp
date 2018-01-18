//
//  QuestionMO+CoreDataClass.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/15/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//
//

import Foundation
import CoreData

public class QuestionMO: NSManagedObject {
    func convertedPlainObject() -> Question {
        guard let category = self.category?.convertedPlainObject() else { fatalError("Error") }
        return Question(id: Int(self.id),
                        category: category,
                        text: self.text ?? "",
                        answers: self.answers ?? [],
                        correctAnswerIndex: Int(self.correctAnswerIndex))
    }
    
    func setup(from question: Question) {
        self.id = Int32(question.id)
        self.text = question.text
        self.correctAnswerIndex = Int32(question.correctAnswerIndex)
        self.answers = question.answers
    }
}
