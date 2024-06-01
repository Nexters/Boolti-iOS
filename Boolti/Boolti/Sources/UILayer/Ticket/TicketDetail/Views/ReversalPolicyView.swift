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

    private enum Constants {
        static let booltiDomain = "@스튜디오불티"
    }

    private let disposeBag = DisposeBag()
    private var isCollapsed: Bool = false {
        didSet {
            self.toggleViewCollapsableImageView()
        }
    }

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

    private let viewCollapseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronDown

        return imageView
    }()

    private lazy var reversalPolicyLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 0, left: 25, bottom: 24, right: 20))
        label.text = AppInfo.reversalPolicy
        label.numberOfLines = 0
        label.setHeadIndent()
        label.setUnderLine(to: Constants.booltiDomain)
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

        if !isWithoutBoard {
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.grey80.cgColor
        } else {
            self.backgroundColor = .grey90
        }

        self.titleView.addSubviews([
            self.titleLabel, self.viewCollapseImageView
        ])

        self.addArrangedSubviews([
            self.titleView,
            self.reversalPolicyLabel
        ])

        self.titleView.snp.makeConstraints { make in
            make.height.equalTo(66)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleView.snp.left).inset(20)
        }

        self.viewCollapseImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.titleView.snp.right).inset(20)
        }
    }

    private func bindUIComponents() {
        self.titleView.rx.tapGesture()
            .skip(1)
            .bind(with: self) { owner, _ in
                owner.isCollapsed.toggle()
                owner.reversalPolicyLabel.isHidden.toggle()
                owner.didViewCollapseButtonTap.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func toggleViewCollapsableImageView() {
        switch self.isCollapsed {
        case true:
            self.viewCollapseImageView.image = .chevronUp
        case false:
            self.viewCollapseImageView.image = .chevronDown
        }
    }


}
