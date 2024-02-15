////
////  TicketInformationView.swift
////  Boolti
////
////  Created by Miro on 1/30/24.
////

import UIKit

class TicketInformationView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey10
        label.font = .aggroB(20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2

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

    private let stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true

        return imageView
    }()

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init("#000000").withAlphaComponent(0.8)
        view.isHidden = true

        return view
    }()

    init() {
        super.init(frame: CGRect())
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: TicketItemEntity) {
        self.dateLabel.text = item.date
        self.locationLabel.text = " | \(item.location)"
        self.titleLabel.text = item.title
        self.qrCodeImageView.image = item.qrCode
        self.titleLabel.setLineSpacing(lineSpacing: 4)
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
            make.height.equalTo(75)
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(70)
        }

        self.dimmedView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.center.equalTo(self.qrCodeImageView)
        }

        self.verticalInformationStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(self.qrCodeImageView.snp.centerY)
            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-12)
        }

        self.stampImageView.snp.makeConstraints { make in
            make.center.equalTo(self.qrCodeImageView)
        }
    }

    private func configureStamp(with item: TicketItemEntity) {
        let ticketStatus = item.ticketStatus
        guard let stampImage = ticketStatus.stampImage else { return }

        self.dimmedView.isHidden = false
        self.stampImageView.isHidden = false

        self.stampImageView.image = stampImage
    }
}
