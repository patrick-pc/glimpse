//
//  User.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var fcmToken: String
}
