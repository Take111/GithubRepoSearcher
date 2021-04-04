//
//  RepoListViewModel.swift
//  GithubRepoSearcherTests
//
//  Created by 竹ノ内愛斗 on 2021/04/04.
//

import XCTest
@testable import GithubRepoSearcher
import Combine

class RepoListViewModelTests: XCTestCase {

    var mockSearchRepositoryUseCase: SearchRepositoryUseCaseMock!
    var viewModel: RepoListViewModel!
    var cancellables = Set<AnyCancellable>()


    override func setUpWithError() throws {
        mockSearchRepositoryUseCase = SearchRepositoryUseCaseMock()
        viewModel = RepoListViewModel(useCase: mockSearchRepositoryUseCase)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


    func testSuccessSearchRepo() {
        mockSearchRepositoryUseCase.searchRepositoryHandler = { (_) -> AnyPublisher<Repositories, Error> in
            Future<Repositories, Error> { promise in
                promise(.failure(NSError(domain: "", code: 0, userInfo: [:])))
            }.eraseToAnyPublisher()
        }
        viewModel.onAppear()

        viewModel.outputs.effect.sink { value in
            switch value {
            case .error:
                XCTAssert(true)
            }
        }.store(in: &cancellables)

        viewModel.inputs.searchText.send("i")
        viewModel.inputs.searchText.send("i")
    }
}
