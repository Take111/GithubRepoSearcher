//
//  RepositoryCell.swift
//  GithubRepoSearcher
//
//  Created by 竹ノ内愛斗 on 2020/11/29.
//

import UIKit

final class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var privateLabel: UILabel! {
        didSet {
            privateLabel.textColor = .red
        }
    }
    @IBOutlet private weak var starLabel: UILabel!

}

extension RepositoryCell {

    func configureCell(item: Repository) {
        nameLabel.text = "Repo名: " + item.name
        starLabel.text = "スター数: " + String(item.stargersCount)
        privateLabel.isHidden = !item.isPrivate
    }
}
