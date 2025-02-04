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
        label.backgroundColor = .grey80.withAlphaComponent(0.8)
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
            .throttle(.seconds(2))
            .drive(with: self) { owner, message in
                owner.toastLabel.text = message
                
                UIView.animate(
                    withDuration: 0.3,
                    delay: 2,
                    options: [],
                    animations: {
                        owner.isHidden = false
                        owner.alpha = 0
                    },
                    completion: { _ in
                        owner.alpha = 1.0
                        owner.isHidden = true
                    })
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
