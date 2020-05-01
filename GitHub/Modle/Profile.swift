//
//  Profile.swift
//  GitHub
//
//  Created by Admin on 4/10/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
struct Profile: Codable {
    let login: String?
    let id: Int?
    let avatarURL , reposURL: String?
    let name, location, email, bio: String?
    let followers, following: Int?
    let createdAt: String?
    var publicRepos : Int?
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
        case name, location, email, bio
        case followers, following
        case createdAt = "created_at"
        case publicRepos = "public_repos"
    }
}

