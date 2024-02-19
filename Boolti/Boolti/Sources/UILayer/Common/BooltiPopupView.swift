//
//  BooltiPopupView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/19/24.
//

import UIKit

import RxSwift
import RxRelay

final class BooltiPopupView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()

    let showPopup = PublishRelay<String>()
    
    // MARK: UI Component
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        return view
    }()
    
    private let popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.numberOfLines = 0
        label.textColor = .grey15
        return label
    }()
    
    private let confirmButton = BooltiButton(title: "확인")
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.configureConstraints()
        self.bindInputs()
        self.bindOutputs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Methods

extension BooltiPopupView {
    
    private func bindInputs() {
        self.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                // TODO: 일단 네트워크 에러일 때 기준
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(1)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.showPopup
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.titleLabel.text = message
                owner.titleLabel.setAlignCenter()
                owner.isHidden = false
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension BooltiPopupView {
    
    private func configureUI() {
        self.addSubviews([self.dimmedBackgroundView,
                          self.popupBackgroundView,
                          self.titleLabel,
                          self.confirmButton])
        self.isHidden = true
    }
    
    private func configureConstraints() {
        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.popupBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.popupBackgroundView).offset(32)
            make.horizontalEdges.equalTo(self.popupBackgroundView).inset(20)
        }
        
        self.confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalTo(self.popupBackgroundView).inset(20)
        }
    }
}
