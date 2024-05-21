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

    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = .qrIcon

        return imageView
    }()

    private let qrCodeBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white00.cgColor
        view.layer.borderWidth = 1

        view.layer.shadowColor = UIColor.white00.cgColor
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 1

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
    }
    
    func resetData() {
        self.dateLabel.text = nil
        self.locationLabel.text = nil
        self.titleLabel.text = nil
    }

    private func configureUI() {

        self.addSubviews([
            self.qrCodeBorderView,
            self.qrCodeImageView,
            self.verticalInformationStackView
        ])

        self.configureConstraints()
    }

    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(75)
        }

        self.qrCodeBorderView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(58)
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.center.equalTo(self.qrCodeBorderView)
            make.size.equalTo(32)
        }

        self.verticalInformationStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(self.qrCodeBorderView.snp.centerY)
            make.right.equalTo(self.qrCodeBorderView.snp.left).offset(-12)
        }
    }
}
