//
//  ViewController.swift
//  JGithubSearch
//
//  Created by 권회경 on 2022/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = JGitHubMainViewModel()
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bind()
    }
    
    private func bind() {
        searchButton.rx.tap
            .bind(to: viewModel.searchingRelay)
            .disposed(by: disposeBag)
        
        viewModel.searchSubject
            .observe(on: MainScheduler.instance)
            .bind(to: searchTableView.rx.items(cellIdentifier: "JGitHubMainTableViewCell", cellType: JGitHubMainTableViewCell.self)) { index, item, cell in
                cell.title.text = item.full_name
            }
            .disposed(by: disposeBag)
    }
}

