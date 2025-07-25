//
//  Item.swift
//  BirthdayApp
//
//  Created by Jolin Wang on 7/25/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
