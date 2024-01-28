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
        stackView.addArrangedSubViews([self.ticketTypeLabel, self.numberLabel])

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
        stackView.addArrangedSubViews([self.dateLabel, self.locationLabel])

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
            by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        )
    }

    func configure(with usedTicket: UsedTicket) {
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true

        self.posterImageView = PosterImageView(image: usedTicket.poster, ellipseWidth: 12)
        self.dateLabel.text = usedTicket.date
        self.numberLabel.text = "﹒ \(usedTicket.number)매"
        self.titleLabel.text = usedTicket.title
        self.locationLabel.text = " | \(usedTicket.location)"
        self.ticketTypeLabel.text = usedTicket.ticketType.description

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

    private func configureConstraints() {
        self.contentView.backgroundColor = .grey90

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
