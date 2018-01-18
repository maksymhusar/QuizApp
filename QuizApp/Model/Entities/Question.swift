//
//  Question.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/25/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Question {
    let id: Int
    let category: Category
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

extension Question {
    init?(json: JSON) {
        guard let id = json["id"].int,
              let text = json["question"].string,
              let category = Category(json: json["category"])
            else {
                return nil
        }
        self.id = id
        self.text = text
        self.category = category
        correctAnswerIndex = json["answers"].intValue - 1

        var currentAnswers = [String]()
        var answerIndex = 1
        
        while let answer = json["option\(answerIndex)"].string {
            currentAnswers.append(answer)
            answerIndex += 1
        }
        
        self.answers = currentAnswers
    }
}
