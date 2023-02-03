//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by wons on 2023/02/02.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    let sortButtonTapped = PublishRelay<Void>()
    let shouldUpdateType: Observable<Void>
    
    init() {
        self.shouldUpdateType = sortButtonTapped
            .asObservable()
    }
}
