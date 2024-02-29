//
//  TicketInformationView.swift
//  Boolti
//
//  Created by Miro on 1/30/24.
//

import UIKit

final class TicketInformationView: UIView {

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .aggroB(20)
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
        self.configureStamp(with: item.ticketStatus)
    }
    
    func resetData() {
        self.dateLabel.text = nil
        self.locationLabel.text = nil
        self.titleLabel.text = nil
        self.qrCodeImageView.image = .qrCode
        self.configureStamp(with: .notUsed)
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
            make.size.equalTo(70)
        }

        self.dimmedView.snp.makeConstraints { make in
            make.size.equalTo(70)
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

    private func configureStamp(with status: TicketStatus) {
        guard let stampImage = status.stampImage else {
            self.dimmedView.isHidden = true
            self.stampImageView.isHidden = true
            return
        }

        self.dimmedView.isHidden = false
        self.stampImageView.isHidden = false

        self.stampImageView.image = stampImage
    }
}
