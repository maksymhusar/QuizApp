//
//  QuizEndpoint.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/27/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire

enum QuizEndpoint: Endpoint {
    case categories
    case questions(category: Category)
}

// MARK: - Endpoint
extension QuizEndpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .categories:
            return "categories"
        case .questions(let category):
            return "categories/\(category.id)/questions"
        }
    }
    
    var parameters: [String: Any]? {
        return ["limit": 20]
    }
}
