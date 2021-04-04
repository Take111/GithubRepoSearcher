//
//  RepoListViewModel.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import Foundation
import Combine

protocol RepoListViewModelInput {
    var searchText: PassthroughSubject<String, Never> { get }
}

protocol RepoListViewModelOutput {
    var repositories: PassthroughSubject<[Repository], Never> { get }
    var effect: PassthroughSubject<RepoListViewModelEffect, Never> { get }
}

protocol RepoListViewModelType {
    var inputs: RepoListViewModelInput { get }
    var outputs: RepoListViewModelOutput { get }
}

final class RepoListViewModel: RepoListViewModelType, RepoListViewModelInput, RepoListViewModelOutput {

    // MARK: - RepoListViewModelInput

    var searchText = PassthroughSubject<String, Never>()

    // MARK: - RepoListViewModelOutput

    var repositories = PassthroughSubject<[Repository], Never>()
    var effect = PassthroughSubject<RepoListViewModelEffect, Never>()

    // MARK: - RepoListViewModelType

    var inputs: RepoListViewModelInput { return self }
    var outputs: RepoListViewModelOutput { return self }

    private var cancellables = Set<AnyCancellable>()

    private let useCase: SearchRepositoryUseCase

    init(useCase: SearchRepositoryUseCase) {
        self.useCase = useCase
    }

    func onAppear() {
        searchText
            .dropFirst() // ""を検索に入れたくないため
            .sink {[weak self] word in
                self?.requestRepository(word: word)
            }
            .store(in: &cancellables)
    }

    private func requestRepository(word: String) {
        useCase.searchRepository(word: word)
            .sink {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("RepoListViewModel: requestRepository: success")
                case .failure(let error):
                    self.repositories.send([])
                    self.outputs.effect.send(.error)
                    print("RepoListViewModel: requestRepository: failure", error.localizedDescription)
                }
            } receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.repositories.send(value.items)
            }
            .store(in: &cancellables)
    }
}

enum RepoListViewModelEffect {
    case error
}


