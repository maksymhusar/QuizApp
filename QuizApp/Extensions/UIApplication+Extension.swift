//
//  UIApplication+Extension.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/18/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

extension UIApplication {
    static func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController, let selectedController = tabController.selectedViewController {
            return topViewController(selectedController)
        }
        
        if let presentedController = controller?.presentedViewController {
            return topViewController(presentedController)
        }
        return controller
    }
}
