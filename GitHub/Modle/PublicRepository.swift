//
//  PublicRepositories.swift
//  GitHub
//
//  Created by Admin on 4/30/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import Foundation
struct PublicRepository: Codable {
    let name: String?
    let gitURL: String?
    let forksCount: Int?
    let stargazersCount: Int?
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case gitURL = "html_url"
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
    }
}
