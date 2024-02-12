//
//  ReservationHorizontalStackView.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

enum ReservationContentAlignment {
    case left
    case right
}

final class ReservationHorizontalStackView: UIStackView {

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

    init(title: String, alignment: ReservationContentAlignment) {
        super.init(frame: .zero)

        self.configureUI(title: title, alignment: alignment)
        self.configureConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(title: String, alignment: ReservationContentAlignment) {

        self.titleLabel.text = title

        self.axis = .horizontal
        self.alignment = .fill
        self.spacing = 20

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
            make.width.greaterThanOrEqualTo(235)
            make.height.equalTo(32)
        }
    }
}
