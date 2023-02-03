//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by wons on 2023/02/02.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    let filterViewModel = FilterViewModel()
    
    let blogListCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogListCellData
            .asDriver(onErrorJustReturn: [])
    }
}
