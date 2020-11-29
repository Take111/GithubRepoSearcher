//
//  RepoListViewController.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import UIKit
import Combine

final class RepoListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let viewModel: RepoListViewModel

    init(viewModel: RepoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onAppear()
        bind()
    }

    private func bind() {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .sink {[weak self] notification in
                guard let self = self else { return }
                if let textField = notification.object as? UITextField, let text = textField.text {
                    self.viewModel.searchText = text
                }
            }.store(in: &cancellables)

        viewModel.$repositories
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension RepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell else { fatalError("No implemented") }
        cell.configureCell(item: viewModel.repositories[indexPath.row])
        return cell
    }
}
