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
    @objc dynamic let title: String = ""
    @objc dynamic let done: Bool = false
}

