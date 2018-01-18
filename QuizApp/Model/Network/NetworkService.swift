//
//  NetworkService.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/27/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkService {
    private static var baseURL: String {
        return "https://qriusity.com/v1/"
    }
    
    // completionHandler performed NOT in the main thread
    static func request(endpoint: Endpoint,
                        completionHandler: ((Result<Any>) -> Void)? = nil) {
        guard Reachability.isInternetAvailable else {
            NotificationCenter.default.post(name: .InternetNotAvailable, object: nil)
            return
        }
        
        let encoding: ParameterEncoding = (endpoint.method == .get || endpoint.method == .delete) ? URLEncoding.default : JSONEncoding.default
        Alamofire.request(baseURL + endpoint.path,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: encoding).responseJSON(queue: DispatchQueue.global()) { networkResponse in
                                completionHandler?(networkResponse.result)
                            }
    }
}
