//
//  Category.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/25/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {
    let id: Int
    let name: String
}

extension Category {
    init?(json: JSON) {
        guard let id = json["id"].int,
              let name = json["name"].string else {
            return nil
        }
        self.id = id
        self.name = name
    }
}
