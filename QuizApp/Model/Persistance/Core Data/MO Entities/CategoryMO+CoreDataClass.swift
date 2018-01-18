//
//  CategoryMO+CoreDataClass.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/15/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//
//

import Foundation
import CoreData

public class CategoryMO: NSManagedObject {
    func convertedPlainObject() -> Category {
        return Category(id: Int(self.id), name: self.name ?? "")
    }
    
    func setup(from category: Category) {
        self.id = Int32(category.id)
        self.name = category.name
    }
}
