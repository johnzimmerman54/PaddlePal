//
//  User.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var email: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var createdDate: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
