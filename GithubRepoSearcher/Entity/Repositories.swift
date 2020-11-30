//
//  Repositories.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import Foundation

struct Repositories: Codable {

    let totalCount: Int
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct Repository: Codable, Hashable {

    let id: Int
    let name: String
    let isPrivate: Bool
    let stargersCount: Int

    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isPrivate = "private"
        case stargersCount = "stargazers_count"
    }
}
