//
//  TicketReservationsTableViewCell.swift
//  Boolti
//
//  Created by Miro on 2/9/24.
//

import UIKit

final class TicketReservationsTableViewCell: UITableViewCell {

    private let reservationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(14)
        label.textColor = .grey50

        return label
    }()

    private let detailNavigationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(14)
        label.textColor = .grey50
        label.text = "상세 보기"

        return label
    }()

    private let detailNavigationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .navigate

        return imageView
    }()

    private let seperationLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.grey85.cgColor
        view.layer.borderWidth = 1

        return view
    }()

    private let concertPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey50.cgColor
        imageView.clipsToBounds = true

        return imageView
    }()

    private let reservationStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(14)
        label.textColor = .grey30

        return label
    }()

    private let concertTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .aggroB(16)
        label.textColor = .grey05

        return label
    }()

    private let reservationDetailLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .grey30

        return label
    }()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }

    func setData(with ticketReservation: TicketReservationItemEntity) {
        self.configureUI()
        
        self.reservationDateLabel.text = ticketReservation.reservationDate.formatToDate().format(.dateTime)
        self.concertPosterImageView.setImage(with: ticketReservation.concertImageURLPath)
        self.reservationStatusLabel.text = ticketReservation.reservationStatus.description
        self.reservationStatusLabel.textColor = ticketReservation.reservationStatus.color
        self.concertTitleLabel.text = ticketReservation.concertTitle
        self.reservationDetailLabel.text = "\(ticketReservation.ticketName) / \(ticketReservation.ticketCount)매 / \(ticketReservation.ticketPrice.formattedCurrency())원"

    }

    private func configureUI() {
        self.backgroundColor = .grey95
        self.contentView.backgroundColor = .grey90

        self.contentView.addSubviews([
            self.reservationDateLabel,
            self.detailNavigationLabel,
            self.detailNavigationImage,
            self.seperationLineView,
            self.concertPosterImageView,
            self.reservationStatusLabel,
            self.concertTitleLabel,
            self.reservationDetailLabel
        ])

        self.reservationDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(20)
        }

        self.detailNavigationImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.reservationDateLabel)
            make.right.equalToSuperview().inset(20)
        }

        self.detailNavigationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.reservationDateLabel)
            make.right.equalTo(self.detailNavigationImage.snp.left)
        }

        self.seperationLineView.snp.makeConstraints { make in
            make.top.equalTo(self.reservationDateLabel.snp.bottom).offset(14)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.concertPosterImageView.snp.makeConstraints { make in
            make.height.equalTo(84)
            make.width.equalTo(60)
            make.left.equalTo(self.reservationDateLabel)
            make.top.equalTo(self.reservationDateLabel.snp.bottom).offset(26)
        }

        self.reservationStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.concertPosterImageView.snp.top).inset(5)
            make.left.equalTo(self.concertPosterImageView.snp.right).offset(16)
        }

        self.concertTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.reservationStatusLabel)
            make.centerY.equalTo(self.concertPosterImageView)
            make.right.equalToSuperview().inset(20)
        }

        self.reservationDetailLabel.snp.makeConstraints { make in
            make.left.equalTo(self.reservationStatusLabel)
            make.bottom.equalTo(self.concertPosterImageView.snp.bottom).inset(5)
        }
    }

}
