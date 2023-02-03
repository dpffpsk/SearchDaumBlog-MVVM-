//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by wons on 2023/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// View에서 이벤트에 관련한 것들은 모두 ViewModel로 전달
class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    /*
    // 뷰에서 가지고 있지 않아도 되는 코드 -> ViewModel
    // searchbar 버튼 탭 이벤트
    // subject를 쓸 수 있지만 error를 받지 않고 UI의 이벤트에 특화된 relay 사용
    // 버튼의 경우 별다른 값을 전달하지 않고 주로 탭 이벤트만 전달되기 때문에 void라고 표현
    let searchButtonTapped = PublishRelay<Void>()
    
    // searchbar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                // 버튼 탭 이벤트가 발생하는 경우
                self.rx.searchButtonClicked.asObservable(), // 키보드 엔터
                searchButton.rx.tap.asObservable() // 버튼 탭
            )
            .bind(to: searchButtonTapped) // 둘 중 하나라도 이벤트가 발생할 때 마다 binding 된 relay로 전달 됨
            .disposed(by: disposeBag)
        
        // 버튼 탭 이벤트가 발생했을 때
        searchButtonTapped
            .asSignal() // asSignal : Observalbe -> Signal로 변환
            .emit(to: self.rx.endEditing) // 구독(subscribe)
            .disposed(by: disposeBag)
        
        /*
        // 뷰에서 가지고 있지 않아도 되는 코드 -> ViewModel
        // 버튼 탭 이벤트가 발생했을 때 최신 값(빈값, 중복값 없이)을 전달
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
         */
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout(){
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

// EndEditing Custom
extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
