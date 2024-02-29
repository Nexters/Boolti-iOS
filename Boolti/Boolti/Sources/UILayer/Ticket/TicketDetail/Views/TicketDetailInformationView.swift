//
//  TicketMainInformationView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

final class TicketDetailInformationView: UIView {

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .aggroB(20)
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

    private let dateLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body2

        return label
    }()

    private let locationLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body2
        label.numberOfLines = 1

        return label
    }()

    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        return imageView
    }()

    private let stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true

        return imageView
    }()

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.8)
        view.isHidden = true

        return view
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
        self.dateLabel.text = item.date.formatToDate().format(.dateDay)
        self.locationLabel.text = " | \(item.location)"
        self.titleLabel.text = item.title
        self.qrCodeImageView.image = item.qrCode
        self.configureGradient()
        self.configureStamp(with: item)
    }

    private func configureUI() {
        self.addSubviews([
            self.qrCodeImageView,
            self.dimmedView,
            self.stampImageView,
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

        self.dimmedView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.center.equalTo(self.qrCodeImageView)
        }

        self.stampImageView.snp.makeConstraints { make in
            make.center.equalTo(self.qrCodeImageView)
        }
    }

    private func configureGradient() {
        let gradientLayer = CAGradientLayer()
        let bounds = CGRect(x: 1, y: 0, width: self.bounds.width-2, height: self.bounds.height)
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black100.withAlphaComponent(0.0).cgColor, UIColor.black100.withAlphaComponent(1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func configureStamp(with item: TicketDetailItemEntity) {
        let ticketStatus = item.ticketStatus
        guard let stampImage = ticketStatus.stampImage else { return }

        self.dimmedView.isHidden = false
        self.stampImageView.isHidden = false

        self.stampImageView.image = stampImage
    }

}
