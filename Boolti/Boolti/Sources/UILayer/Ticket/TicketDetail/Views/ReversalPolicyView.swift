//
//  ReversalPolicyView.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class ReversalPolicyView: UIStackView {

    private let disposeBag = DisposeBag()

    let didViewCollapseButtonTap = PublishRelay<Void>()

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "취소/환불 규정"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()

    private let viewCollapseButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDown, for: .normal)
        button.setImage(.chevronUp, for: .selected)
        return button
    }()

    private lazy var reversalPolicyLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20))
        label.text = """
        • 티켓 판매 기간 내 발권 취소 및 환불은 서비스 내 처리가 가능하며, 판매 기간 이후에는 주최자에게 직접 연락 바랍니다.
        • 티켓 판매 기간 내 환불 신청은 발권 후 마이 > 예매 내역 > 예매 상세에서 가능합니다.
        • 계좌 이체를 통한 환불은 환불 계좌 정보가 필요하며 영업일 기준 약 1~2일이 소요됩니다.
        • 환불 수수료는 부과되지 않습니다.
        • 기타 사항은 카카오톡 채널 @스튜디오불티로 문의 부탁드립니다.
        """
        label.numberOfLines = 0
        label.setHeadIndent()
        label.font = .body1
        label.textColor = .grey50
        label.isHidden = true
        return label
    }()

    init(isWithoutBorder: Bool = false) {
        super.init(frame: .zero)
        self.configureUI(isWithoutBorder)
        self.bindUIComponents()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(_ isWithoutBoard: Bool) {
        self.axis = .vertical
        self.clipsToBounds = true

        var titleViewWidth: CGFloat

        if !isWithoutBoard {
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.grey80.cgColor
            titleViewWidth = 317
        } else {
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            titleViewWidth = window.screen.bounds.width
            self.backgroundColor = .grey90
        }

        self.titleView.addSubviews([
            self.titleLabel, self.viewCollapseButton
        ])

        self.addArrangedSubviews([
            self.titleView,
            self.reversalPolicyLabel
        ])

        self.titleView.snp.makeConstraints { make in
//            make.width.equalTo(titleViewWidth)
            make.height.equalTo(66)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleView.snp.left).inset(20)
        }

        self.viewCollapseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.titleView.snp.right).inset(20)
        }

        self.reversalPolicyLabel.snp.makeConstraints { make in
            make.height.equalTo(290)
        }
    }

    private func bindUIComponents() {
        self.viewCollapseButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewCollapseButton.isSelected.toggle()

                UIView.animate(withDuration: 0.3) {
                    owner.reversalPolicyLabel.isHidden.toggle()
                    owner.layoutIfNeeded()
                }
                owner.didViewCollapseButtonTap.accept(())
            }
            .disposed(by: self.disposeBag)
    }

}
