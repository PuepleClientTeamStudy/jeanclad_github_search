//
//  ViewController.swift
//  JGithubSearch
//
//  Created by 권회경 on 2022/11/29.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancelBag = Set<AnyCancellable>()
    
    let viewModel = JGitHubMainViewModel()
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTableView.dataSource = self
        bind()
    }
    
    @objc private func requestSearchRepo() {
        viewModel.githubSearchModel
            .publisher
            .sink(receiveValue: { [weak self] _ in
                self?.searchTableView.reloadData()
            })
            .store(in: &cancelBag)
    }
    
    private func bind() {
        searchButton.addTarget(self,
                               action: #selector(requestSearchRepo),
                               for: .touchUpInside)
    }
}

// MARK: UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.githubSearchModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: JGitHubMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JGitHubMainTableViewCell") as! JGitHubMainTableViewCell
        
        if let viewModel = viewModel.githubSearchModel {
            cell.textLabel?.text = viewModel.items[indexPath.row].full_name
        }
        
        return cell
    }
}
