//
//  JGitHubMainVIewModel.swift
//  JGithubSearch
//
//  Created by 권회경 on 2022/11/29.
//

import Foundation
import Combine

class JGitHubMainViewModel {
    var cancelBag = Set<AnyCancellable>()
    
    @Published public var githubSearchModel: JGitHubSearchModel?
       
    init() {
        bind()
    }
    
    // MARK: Private
    
    private func bind() {
        fetchGitHubSearchKeyworkWithCombine(with: "RxSwift")
    }
    
    private func fetchGitHubSearchKeyworkWithCombine(with keyword: String) {
        APIService().searchReposeCombine(with: keyword, type: JGitHubSearchModel.self)
            .sink(receiveCompletion: {
                print("recived = \($0)")
            }, receiveValue: { [weak self] response in
                self?.githubSearchModel = response
            })
            .store(in: &cancelBag)
    }
}
