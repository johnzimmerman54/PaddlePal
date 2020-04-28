//
//  Data.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var tripName: String = ""
    @objc dynamic var date: Date = Date()
}
