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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(16)
        label.textColor = .grey30
        label.textAlignment = .left
        label.text = "은행명"

        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(16)
        label.textColor = .grey15
        label.text = "신한은행"

        return label
    }()

    // 추후에 어느 button이든 넣을 수 있게 구현하기! -> 현재는 하나 밖에 없어서 그냥 프로퍼티로 정의
    private let copyButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "복사"
        config.attributedTitle?.font = .pretendardR(12)
        config.background.backgroundColor = .grey85
        config.baseForegroundColor = .grey05
        config.background.cornerRadius = 4
        config.imagePadding = 6

        let button = UIButton(configuration: config)
        button.setImage(.copy, for: .normal)
        button.isHidden = true

        return button
    }()

    init(title: String, alignment: ReservationContentAlignment, isCopyButtonExist: Bool = false) {
        super.init(frame: .zero)

        self.configureUI(title: title, alignment: alignment, isCopyButtonExist: isCopyButtonExist)
        self.configureConstraints()
        self.bindUIComponents()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(
        title: String,
        alignment: ReservationContentAlignment,
        isCopyButtonExist: Bool
    ) {
        self.copyButton.isHidden = !isCopyButtonExist
        self.titleLabel.text = title

        self.axis = .horizontal
        self.alignment = .fill
        self.spacing = 20

        self.contentLabel.addSubview(self.copyButton)
        self.configureAlignment(alignment)
        self.addArrangedSubviews([
            self.titleLabel,
            self.contentLabel
        ])
    }

    func setData(_ content: String) {
        self.contentLabel.text = content
    }

    private func configureAlignment(_ alignment: ReservationContentAlignment) {

        switch alignment {
        case .left:
            self.contentLabel.textAlignment = .left
        case .right:
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
            make.width.equalTo(80)
            make.height.equalTo(32)
        }

        self.contentLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
        }

        self.copyButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

    }

    private func bindUIComponents() {

        guard !copyButton.isHidden else { return }
        self.copyButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.didCopyButtonTap.accept(owner.contentLabel.text ?? "")
            })
            .disposed(by: self.disposeBag)
    }
}
