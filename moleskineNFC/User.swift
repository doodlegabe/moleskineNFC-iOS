//
//  User.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/21/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var email: String
    var firstName: String
    var lastName: String
    var createdAt: String
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt
        case updatedAt
    }
}
