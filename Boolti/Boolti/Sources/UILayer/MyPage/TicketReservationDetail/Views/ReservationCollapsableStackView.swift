//
//  ReservationCollapsableStackView.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

import RxSwift
import RxRelay
import RxGesture

final class ReservationCollapsableStackView: UIStackView {

    private let disposeBag = DisposeBag()
    private var isCollapsed: Bool = false {
        didSet {
            self.toggleViewCollapsableImageView()
        }
    }

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()

    private let viewCollapseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronDown
        
        return imageView
    }()

    private let additionalSpacingView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String, contentViews: [UIView], isHidden: Bool) {

        super.init(frame: .zero)
        self.configureUI(title: title, contentViews: contentViews, isHidden: isHidden)
        self.bindUIComponents()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(title: String, contentViews: [UIView], isHidden: Bool) {

        self.axis = .vertical
        self.spacing = 16
        self.alignment = .center
        self.backgroundColor = .grey90
        self.titleLabel.text = title
        self.isUserInteractionEnabled = true
        self.isCollapsed = !isHidden

        let collapsableSubviews = contentViews + [self.additionalSpacingView]
        collapsableSubviews.forEach { $0.isHidden = isHidden }

        let subviews = [self.titleView] + collapsableSubviews
        self.addArrangedSubviews(subviews)

        self.titleView.addSubviews([
            self.titleLabel, self.viewCollapseImageView
        ])

        self.setCustomSpacing(0, after: self.titleView)
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

        self.viewCollapseImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }

    private func bindUIComponents() {
        let collapsableSubviews = self.arrangedSubviews.filter { $0 != self.titleView }
        self.titleView.rx.tapGesture()
            .skip(1)
            .bind(with: self) { owner, _ in
                owner.isCollapsed.toggle()
                collapsableSubviews.forEach { $0.isHidden.toggle() }
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
