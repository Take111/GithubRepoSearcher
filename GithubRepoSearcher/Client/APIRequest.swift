//
//  APIRequest.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/12/05.
//

import Foundation

protocol APIRequest {
    associatedtype ResponceEntity: Decodable

    var baseURL: String { get }
    var queryItems: [URLQueryItem]? { get }
}

enum GithubAPI {

    struct searchRepo: APIRequest {
        typealias ResponceEntity = Repositories
        var baseURL: String { "https://api.github.com/search/repositories" }
        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "q", value: word)]
        }
        var word: String
    }
}
