//
//  User.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    var id: String
    var name: String
    var email: String
    var fcmToken: String
}
