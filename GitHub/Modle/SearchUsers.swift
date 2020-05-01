//
//  SearchUsers.swift
//  GitHub
//
//  Created by Admin on 4/11/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
struct SearchUsers: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    var items: [SearchUser]?
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct SearchUser: Codable {
    let login: String?
    let avatarURL: String?
    var url: String?
    var numberOfRepo : Int?
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case url
        case numberOfRepo
    }
}


