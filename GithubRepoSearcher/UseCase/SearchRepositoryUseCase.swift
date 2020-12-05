//
//  SearchRepositoryUseCase.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import Foundation
import Combine

protocol SearchRepositoryUseCase {
    func searchRepository(word: String) -> AnyPublisher<Repositories, Error>
}

final class SearchRepositoryUseCaseImpl: SearchRepositoryUseCase {

    private let apiClient = APIClientImpl()

    func searchRepository(word: String) -> AnyPublisher<Repositories, Error> {
        return apiClient.request(GithubAPI.searchRepo(word: word))
    }
}
