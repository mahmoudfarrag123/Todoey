//
//  Category.swift
//  Todoey
//
//  Created by MAHMOUD on 3/10/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name:String=""
    let item_relationShip=List<Item>()
}
