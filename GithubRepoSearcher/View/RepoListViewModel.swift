//
//  RepoListViewModel.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import Foundation
import Combine

final class RepoListViewModel {

    // TODO: 本当はこっちを使いたい
//    private let useCase: SearchRepositoryUseCase

    // TODO: これは邪道　DI方法がまずい
    private var useCase = SearchRepositoryUseCaseImpl()

    private var cancellables = Set<AnyCancellable>()

    @Published var repositories = [Repository]()
    @Published var searchText = ""

    func onAppear() {
        $searchText
            .dropFirst() // ""を検索に入れたくないため
            .sink {[weak self] word in
                self?.requestRepository(word: word)
            }
            .store(in: &cancellables)
    }

    private func requestRepository(word: String) {
        useCase.searchRepository(word: word).print()
            .sink { completion in
                switch completion {
                case .finished:
                    print("RepoListViewModel: requestRepository: success")
                case .failure(let error):
                    print("RepoListViewModel: requestRepository: failure", error)
                }
            } receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.repositories = value.items
            }
            .store(in: &cancellables)
    }
}
