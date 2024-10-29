//
//  Item.swift
//  Swiftly
//
//  Created by Patrick on 10/28/24.
//

import FirebaseFirestore
import Foundation

struct Item: Codable, Identifiable {
    var id: String
    var userId: String
    var title: String
    var description: String
    var createdAt: Timestamp
}
