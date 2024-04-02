//
//  BooltiPopupView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/19/24.
//

import UIKit

import RxSwift
import RxCocoa

final class BooltiPopupView: UIView {
    
    // MARK: Properties
    
    enum PopupType: String {
        case networkError = "네트워크 오류가 발생했습니다\n잠시후 다시 시도해주세요"
        case refreshTokenHasExpired = "로그인 세션이 만료되었습니다\n앱을 다시 시작해주세요"
        case accountRemoveCancelled = "탈퇴 후 30일 이내에 로그인하여,\n계정 삭제가 취소되었어요\n불티를 다시 찾아주셔서 감사해요!"
    }
    
    let disposeBag = DisposeBag()
    var popupType: PopupType = .networkError
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension BooltiPopupView {
    
    func showPopup(with type: PopupType) {
        self.titleLabel.text = type.rawValue
        self.titleLabel.setAlignment(.center)
    
        self.popupType = type
        self.isHidden = false
    }
    
    func didConfirmButtonTap() -> Signal<Void> {
        return self.confirmButton.rx.tap.asSignal()
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
