///
/// @Generated by Mockolo
///



import Combine
import Foundation
@testable import GithubRepoSearcher


class SearchRepositoryUseCaseMock: SearchRepositoryUseCase {
    init() { }


    private(set) var searchRepositoryCallCount = 0
    var searchRepositoryHandler: ((String) -> (AnyPublisher<Repositories, Error>))?
    func searchRepository(word: String) -> AnyPublisher<Repositories, Error> {
        searchRepositoryCallCount += 1
        if let searchRepositoryHandler = searchRepositoryHandler {
            return searchRepositoryHandler(word)
        }
        fatalError("searchRepositoryHandler returns can't have a default value thus its handler must be set")
    }
}

