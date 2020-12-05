//
//  APIClient.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/12/05.
//

import Foundation
import Combine

protocol APIClient {

    func request<T>(_ entity: T) -> AnyPublisher<T.ResponceEntity, Error> where T: APIRequest
}

final class APIClientImpl: APIClient {
    func request<T>(_ entity: T) -> AnyPublisher<T.ResponceEntity, Error> where T : APIRequest {
        let urlSession = URLSession.shared
        var components = URLComponents(string: entity.baseURL)
        components?.queryItems = entity.queryItems

        guard let url = components?.url else {
            // TODO: ここはハンドリングしたい
            fatalError("components URL is nil")
        }
        return urlSession.dataTaskPublisher(for: URLRequest(url: url))
            .tryMap() { element -> Data in
                guard let httpResponce = element.response as? HTTPURLResponse, httpResponce.statusCode == 200 else {
                    // TODO: ここはハンドリングしたい
                    throw URLError(URLError.Code.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.ResponceEntity.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

