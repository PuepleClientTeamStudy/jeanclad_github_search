//
//  JGitHubMainVIewModel.swift
//  JGithubSearch
//
//  Created by 권회경 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa

class JGitHubMainViewModel {
    let disposeBag = DisposeBag()
    
    public let searchingRelay = PublishRelay<Void>()
    public let searchSubject = PublishSubject<[Item]>()
    
    init() {
        bind()
    }
    
    // MARK: Private
    private func bind() {
        searchingRelay
            .flatMapLatest{ [weak self] in
                self?.fetchGitHubSearchKeyword(with: "RxSwift") ?? Observable.empty()
            }
            .map { $0.items }
            .bind(to: searchSubject)
        //            .subscribe { [weak self] data in
        //                self?.searchSubject.onNext(data)
        //            }
            .disposed(by: disposeBag)
    }
    
    private func fetchGitHubSearchKeyword(with keyword: String) -> Observable<JGitHubSearchModel> {
        return Observable.create { emitter in
            
            // TODO: Service는 뷰모델에서 주입받아서 사용
            APIService().searchRepos(with: keyword) { result in
                switch result {
                case let .success(data):
                    
                    guard let output = try? JSONDecoder().decode(JGitHubSearchModel.self,
                                                                 from: data) else {
                        print("Error: JSON data parsing failed")
                        return emitter.onError(APIError.failedJsonDesrialized)
                    }
                    
                    
                    emitter.onNext(output)
                    emitter.onCompleted()
                    
                case let .failure(err):
                    emitter.onError(err)
                }
            }
            
            return Disposables.create()
        }
    }
}
