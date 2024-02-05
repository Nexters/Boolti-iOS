////
////  TicketMainView.swift
////  Boolti
////
////  Created by Miro on 1/30/24.
////

import UIKit

class TicketMainView: UIView {

    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true

        return imageView
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey05
        label.font = .caption

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
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
        stackView.spacing = 2

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

    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4

        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureSeperateLine()
    }

    init() {
        super.init(frame: CGRect())
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: TicketItem) {
        self.posterImageView.image = item.poster
        self.dateLabel.text = item.date
        self.locationLabel.text = " | \(item.location)"
        self.titleLabel.text = item.title
        self.qrCodeImageView.image = item.qrCode
    }

    private func configureUI() {
        self.addSubviews([
            self.posterImageView,
            self.qrCodeImageView,
            self.verticalInformationStackView
        ])

        self.configureConstraints()
    }

    private func configureConstraints() {
        self.posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(1.4)
        }
        
        self.verticalInformationStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-12)
            make.left.equalToSuperview()
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.verticalInformationStackView.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(self.posterImageView.snp.height).multipliedBy(0.18)
            make.width.equalTo(self.qrCodeImageView.snp.height)
        }
    }

    private func configureSeperateLine() {
        let path = UIBezierPath()

        let posterImageViewBottonY = self.posterImageView.bounds.height
        let stackViewTopY = self.verticalInformationStackView.frame.origin.y

        path.move(to: CGPoint(x: 0, y: (posterImageViewBottonY + stackViewTopY)/2))
        path.addLine(to: CGPoint(x: self.bounds.width, y: (posterImageViewBottonY + stackViewTopY)/2))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [3, 3]
        shapeLayer.strokeColor = UIColor.init(white: 1, alpha: 0.3).cgColor
        self.layer.addSublayer(shapeLayer)
    }
}
