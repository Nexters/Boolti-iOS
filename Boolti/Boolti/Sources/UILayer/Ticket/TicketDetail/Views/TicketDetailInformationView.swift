//
//  TicketMainInformationView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketDetailInformationView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey10
        label.font = .aggroB(20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4

        return label
    }()

    private lazy var verticalInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews([
            self.titleLabel,
            self.horizontalInformationStackView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4

        return stackView
    }()

    private lazy var horizontalInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubviews([self.dateLabel, self.locationLabel])

        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey30
        label.font = .body2

        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey30
        label.font = .body2

        return label
    }()

    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        return imageView
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: TicketDetailItemEntity) {
        self.dateLabel.text = item.date
        self.locationLabel.text = " | \(item.location)"
        self.titleLabel.text = item.title
        self.qrCodeImageView.image = item.qrCode
        self.titleLabel.setLineSpacing(lineSpacing: 4)
        self.configureGradient()
    }

    private func configureUI() {
        self.addSubviews([
            self.qrCodeImageView,
            self.verticalInformationStackView
        ])
        self.configureConstraints()
    }

    private func configureConstraints() {

        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(75)
        }

        self.verticalInformationStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-12)
            make.bottom.equalToSuperview()
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.top.equalTo(self.verticalInformationStackView.snp.top).inset(7)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(70)
        }
    }

    private func configureGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.init("#000000").withAlphaComponent(0.0).cgColor, UIColor.init("#000000").withAlphaComponent(0.7).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
