//
//  ReservationCollapsableStackView.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

import RxSwift
import RxRelay

final class ReservationCollapsableStackView: UIStackView {

    let didViewCollapseButtonTap = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
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

    private let additionalSpacingView: UIView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String, contentViews: [UIView], isHidden: Bool) {

        super.init(frame: .zero)
        self.configreUI(title: title, contentViews: contentViews, isHidden: isHidden)
        self.bindUIComponents()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configreUI(title: String, contentViews: [UIView], isHidden: Bool) {

        self.axis = .vertical
        self.spacing = spacing
        self.alignment = .center
        self.backgroundColor = .grey90
        self.titleLabel.text = title
        self.isUserInteractionEnabled = true

        if !isHidden {
            self.viewCollapseButton.isSelected.toggle()
        }

        let collapsableSubviews = contentViews + [self.additionalSpacingView]
        collapsableSubviews.forEach { $0.isHidden = isHidden }

        let subviews = [self.titleView] + collapsableSubviews
        self.addArrangedSubviews(subviews)

        self.titleView.addSubviews([
            self.titleLabel, self.viewCollapseButton
        ])

        self.configureConstraints()
    }

    private func configureConstraints() {

        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        self.titleView.snp.makeConstraints { make in
            make.width.equalTo(window.screen.bounds.width)
            make.height.equalTo(66)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }

        self.viewCollapseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }

        self.additionalSpacingView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }

    private func bindUIComponents() {
        let collapsableSubviews = self.arrangedSubviews.filter { $0 != self.titleView }
        self.viewCollapseButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewCollapseButton.isSelected.toggle()
                collapsableSubviews.forEach { $0.isHidden.toggle() }
                owner.didViewCollapseButtonTap.accept(())
            }
            .disposed(by: self.disposeBag)
    }

}
