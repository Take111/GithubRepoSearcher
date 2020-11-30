//
//  RepoListViewController.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import UIKit
import Combine

final class RepoListViewController: UIViewController {

    enum Section: CaseIterable {
        case main
    }

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Section, Repository>! = nil
    private var snapShot: NSDiffableDataSourceSnapshot<Section, Repository>!

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

        prepareView()

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

        viewModel.$repositories.dropFirst()
            .receive(on: RunLoop.main).print()
            .sink {[weak self] _ in
                guard let self = self else { return }
                // ここで毎回初期化してあげないと、更新されない Appleの公式プロジェクトもこうしてるから正しいのかも
                self.snapShot = NSDiffableDataSourceSnapshot<Section, Repository>()
                self.snapShot.appendSections(Section.allCases)
                self.snapShot.appendItems(self.viewModel.repositories, toSection: .main)
                self.dataSource.apply(self.snapShot, animatingDifferences: true)
            }.store(in: &cancellables)
    }

    private func prepareView() {

        dataSource = UITableViewDiffableDataSource<Section, Repository>(tableView: tableView, cellProvider: {[weak self] (tableView, indexPath, repository) -> UITableViewCell? in
            guard let self = self else { fatalError("No implemented") }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell
            cell?.configureCell(item: self.viewModel.repositories[indexPath.row])
            return cell
        })

        snapShot = NSDiffableDataSourceSnapshot<Section, Repository>()
        snapShot.appendSections(Section.allCases)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
