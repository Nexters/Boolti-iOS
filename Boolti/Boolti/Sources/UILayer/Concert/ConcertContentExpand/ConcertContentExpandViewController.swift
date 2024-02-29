//
//  ConcertContentExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ConcertContentExpandViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertContentExpandViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "공연 내용"))
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.font = .pretendardR(16)
        textView.textColor = .grey30
        return textView
    }()
    
    // MARK: Init
    
    init(viewModel: ConcertContentExpandViewModel) {
        self.viewModel = viewModel
        super.init()
        
        self.configureUI()
        self.configureConstraints()
        self.bindOutputs()
        self.bindNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension ConcertContentExpandViewController {
    
    private func bindOutputs() {
        self.viewModel.output.content
            .bind(with: self) { owner, content in
                owner.contentTextView.text = content
                owner.contentTextView.setLineSpacing(lineSpacing: 6)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ConcertContentExpandViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar, self.contentTextView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.contentTextView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
