//
//  RepoDetailViewController.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/12/05.
//

import UIKit

final class RepoDetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!

    private let name: String

    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "詳細"

        nameLabel.text = name

    }
}
