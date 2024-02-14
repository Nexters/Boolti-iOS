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
            make.height.equalTo(75)
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(70)
        }

        self.verticalInformationStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(self.qrCodeImageView.snp.centerY)
            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-12)
        }
    }

//    private func configureSeperateLine() {
//        let path = UIBezierPath()
//
//        let posterImageViewBottonY = self.posterImageView.bounds.height
//        let stackViewTopY = self.verticalInformationStackView.frame.origin.y
//
//        path.move(to: CGPoint(x: 0, y: (posterImageViewBottonY + stackViewTopY)/2))
//        path.addLine(to: CGPoint(x: self.bounds.width, y: (posterImageViewBottonY + stackViewTopY)/2))
//        path.close()
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.lineWidth = 2
//        shapeLayer.lineDashPattern = [2, 2]
//        shapeLayer.strokeColor = UIColor.init(white: 1, alpha: 0.3).cgColor
//        self.layer.addSublayer(shapeLayer)
//    }
}
