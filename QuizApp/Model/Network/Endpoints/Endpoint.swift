//
//  Endpoint.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/27/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}
