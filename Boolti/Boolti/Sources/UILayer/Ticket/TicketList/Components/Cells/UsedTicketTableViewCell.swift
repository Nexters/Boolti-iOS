//
//  UsedTicketTableViewCell.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

class UsedTicketTableViewCell: UITableViewCell {

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85

        return view
    }()

    private lazy var upperTagLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubviews([self.ticketTypeLabel, self.numberLabel])

        return stackView
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView(image: .booltiLogo)

        return imageView
    }()

    private let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey50
        label.font = .caption

        return label
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey50
        label.font = .caption

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey15
        label.font = .subhead2

        return label
    }()

    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews([self.dateLabel, self.locationLabel])

        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey50
        label.font = .body1

        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey50
        label.font = .body1

        return label
    }()

    private var posterImageView: PosterImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        )
    }

    func setData(with item: UsedTicket) {
        self.configureContentViewUI()

        self.posterImageView = PosterImageView(
            image: item.poster,
            ellipseWidth: 12,
            cornerRadius: 4,
            circleColor: .grey90
        )
        self.dateLabel.text = item.date
        self.numberLabel.text = "﹒ \(item.number)매"
        self.titleLabel.text = item.title
        self.locationLabel.text = " | \(item.location)"
        self.ticketTypeLabel.text = item.ticketType.description

        guard let posterImageView else { return }
        self.contentView.addSubviews([
            self.upperTagView,
            self.upperTagLabelStackView,
            self.booltiLogoImageView,
            self.titleLabel,
            self.informationStackView,
            posterImageView
        ])

        self.configureConstraints()
    }

    private func configureContentViewUI() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.backgroundColor = .grey90
        self.backgroundColor = .grey95
        self.contentView.clipsToBounds = true
    }

    private func configureConstraints() {

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

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }

        self.informationStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.equalTo(self.titleLabel)
        }

        self.posterImageView?.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.top)
            make.width.height.equalTo(80)
            make.right.equalToSuperview().inset(20)
        }
    }
}
