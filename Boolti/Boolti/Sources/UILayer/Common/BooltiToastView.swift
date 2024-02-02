//
//  BooltiToastView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/2/24.
//

import UIKit
import RxSwift
import RxRelay

final class BooltiToastView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()

    let showToast = PublishRelay<String>()
    
    // MARK: UI Component
    
    let toastLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0))
        label.textColor = .grey10
        label.backgroundColor = .grey80
        label.font = .body1
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.configureConstraints()
        self.bindOutputs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Methods

extension BooltiToastView {
    
    private func bindOutputs() {
        self.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                self.toastLabel.text = message
                self.isHidden = false
                
                Observable.just("")
                    .delay(.seconds(2), scheduler: MainScheduler.instance)
                    .asDriver(onErrorJustReturn: "")
                    .drive(with: self) { owner, _ in
                        UIView.animate(
                            withDuration: 0.3,
                            animations: {
                                owner.alpha = 0.0
                            },
                            completion: { _ in
                                owner.isHidden = true
                                owner.alpha = 1.0
                            })
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension BooltiToastView {
    
    private func configureUI() {
        self.addSubview(self.toastLabel)
        self.isHidden = true
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        
        self.toastLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
