//
//  ReservationHorizontalStackView.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

enum ReservationContentAlignment {
    case left
    case right
}

final class ReservationHorizontalStackView: UIStackView {

    private let disposeBag = DisposeBag()

    let didCopyButtonTap = PublishRelay<String>()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardR(16)
        label.textColor = .grey30
        label.textAlignment = .left

        return label
    }()

    private(set) var contentLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardR(16)
        label.textColor = .grey15

        return label
    }()

    init(title: String, alignment: ReservationContentAlignment) {
        super.init(frame: .zero)

        self.configureUI(title: title, alignment: alignment)
        self.configureConstraints()
        self.bindUIComponents()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(
        title: String,
        alignment: ReservationContentAlignment
    ) {
        self.titleLabel.text = title
        self.axis = .horizontal

        self.configureAlignment(alignment)
        self.addArrangedSubviews([
            self.titleLabel,
            self.contentLabel
        ])
    }

    func setData(_ content: String, isUnderLined: Bool = false) {
        self.contentLabel.text = content
        if isUnderLined {
            self.contentLabel.setUnderLine(to: content)
            self.bindUIComponents()
        }
    }

    private func configureAlignment(_ alignment: ReservationContentAlignment) {

        switch alignment {
        case .left:
            self.spacing = 20
            self.distribution = .fill
            self.contentLabel.textAlignment = .left
        case .right:
            self.distribution = .equalSpacing
            self.contentLabel.textAlignment = .right
        }
    }

    private func configureConstraints() {

        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        self.snp.makeConstraints { make in
            make.width.equalTo(window.screen.bounds.width - 40)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }

    private func bindUIComponents() {
        self.contentLabel.rx.tapGesture()
            .skip(1)
            .bind(with: self, onNext: { owner, _ in
                owner.didCopyButtonTap.accept(owner.contentLabel.text ?? "")
            })
            .disposed(by: self.disposeBag)
    }
}
