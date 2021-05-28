//
//  Item.swift
//  Todoey
//
//  Created by Yani Buchkov on 28.05.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // inverse relationship which is made manual. 
}

