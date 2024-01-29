//
//  UsableTicketTableViewCell.swift
//  Boolti
//
//  Created by Miro on 1/28/24.
//

import UIKit

class UsableTicketTableViewCell: UITableViewCell {

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange01

        return view
    }()

    private lazy var upperTagLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubViews([self.ticketTypeLabel, self.numberLabel])

        return stackView
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView(image: .booltiLogoOrange)
        return imageView
    }()

    private let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey05
        label.font = .caption

        return label
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
        label.font = .headline1
        label.numberOfLines = 2

        return label
    }()

    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubViews([self.dateLabel, self.locationLabel])

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

    private var posterImageView: PosterImageView?

    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4

        return imageView
    }()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        )
    }

    func configureData(with item: UsableTicket) {
        self.contentView.backgroundColor = .grey85
        self.backgroundColor = .grey95
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 8

        self.posterImageView = PosterImageView(
            image: item.poster,
            ellipseWidth: 28,
            cornerRadius: 8,
            circleColor: .grey85
        )
        self.dateLabel.text = item.date
        self.locationLabel.text = " | \(item.location)"
        self.titleLabel.text = item.title
        self.numberLabel.text = "﹒ \(item.number)매"
        self.ticketTypeLabel.text = item.ticketType.description
        self.qrCodeImageView.image = item.qrCode

        guard let posterImageView else { return }
        self.contentView.addSubviews([
            self.upperTagView,
            self.upperTagLabelStackView,
            self.booltiLogoImageView,
            posterImageView,
            self.qrCodeImageView,
            self.titleLabel,
            self.informationStackView,
        ])

        self.configureConstraints()
        self.configureGradient()
    }

    private func configureGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 0.4).cgColor, UIColor(white: 1, alpha: 0).cgColor]

        // gradient를 layer 전체에 적용해주기 위해 범위를 0.0 ~ 1.0으로 설정

        // gradient 방향을 x축과는 상관없이 y축의 변화만 줌
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.2, y: 0.3)

        gradient.locations = [0.0, 0.5]

        gradient.frame = bounds
        gradient.cornerRadius = 8
        self.contentView.layer.addSublayer(gradient)
    }

    private func configureConstraints() {

        guard let posterImageView else { return }

        self.upperTagView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(32)
        }

        self.upperTagLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView.snp.centerY)
            make.left.equalToSuperview().inset(20)
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagLabelStackView)
            make.right.equalToSuperview().inset(20)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(380)
        }

        self.qrCodeImageView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(24)
            make.height.equalTo(380)
            make.right.equalTo(posterImageView.snp.right)
            make.width.height.equalTo(80)
            make.width.equalTo(self.qrCodeImageView.snp.height)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.qrCodeImageView.snp.top)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-20)
        }

        self.informationStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.left.equalTo(self.titleLabel)
        }
    }

}
