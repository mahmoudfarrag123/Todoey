//
//  Item.swift
//  Todoey
//
//  Created by MAHMOUD on 3/10/20.
//  Copyright © 2020 MAHMOUD. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    @objc dynamic var dateCreated:Date?
    let parentCategory_relationShip = LinkingObjects(fromType: Category.self, property: "item_relationShip")
}
