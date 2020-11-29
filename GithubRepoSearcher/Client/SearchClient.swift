//
//  SearchClient.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import Foundation
import Combine

protocol SearchClient {
    func request<T: Codable>(_ entity: T.Type, word: String) -> AnyPublisher<T, Error>
}

final class SearchClientImpl: SearchClient {

    // TODO: ここにURLを置くのは良くない
    private let baseURL = "https://api.github.com/search/repositories"
    private let urlSession = URLSession.shared

    func request<T>(_ entity: T.Type, word: String) -> AnyPublisher<T, Error> where T : Decodable, T : Encodable {

        // TODO: ここのComponentsの処理はUseCaseに書く？
        var components = URLComponents(string: baseURL)
        components?.queryItems = [URLQueryItem(name: "q", value: word)]

        guard let url = components?.url else { fatalError() }

        return urlSession.dataTaskPublisher(for: URLRequest(url: url))
            .tryMap() { element -> Data in
                guard let httpResponce = element.response as? HTTPURLResponse, httpResponce.statusCode == 200 else {
                    throw URLError(URLError.Code.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
