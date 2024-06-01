//
//  TicketCollectionViewCell.swift
//  Boolti
//
//  Created by Miro on 5/20/24.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {

    private let loadingIndicatorView = BooltiLoadingIndicatorView(style: .medium)

    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let ticketNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey70
        label.font = .subhead1
        label.textAlignment = .center
        label.backgroundColor = .grey10

        return label
    }()

    private let csTicketLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey70

        return label
    }()

    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .white00.withAlphaComponent(0.9)
        return view
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let ticketStatusLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroM(20)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        self.csTicketLabel.text = ""
        self.qrCodeImageView.image = nil
        self.ticketNameLabel.text = ""
        self.blurView.isHidden = false
        self.ticketStatusLabel.isHidden = false
        self.booltiLogoImageView.isHidden = false
    }

    override func layoutSubviews() {
        self.ticketNameLabel.layer.masksToBounds = true
        self.ticketNameLabel.layer.cornerRadius = 15
    }

    private func configureViews() {
        self.backgroundColor = .white00
        self.addSubviews()
        self.configureConstraints()
    }

    private func addSubviews() {
        self.addSubviews([
            self.ticketNameLabel,
            self.qrCodeImageView,
            self.loadingIndicatorView,
            self.blurView,
            self.booltiLogoImageView,
            self.ticketStatusLabel,
            self.csTicketLabel
        ])
    }

    private func configureConstraints() {


        self.qrCodeImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(178)
        }

        self.loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.ticketNameLabel.snp.makeConstraints { make in
            make.width.equalTo(105)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.qrCodeImageView.snp.top).offset(-16)
        }

        self.csTicketLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrCodeImageView.snp.bottom).offset(12)
        }

        self.blurView.snp.makeConstraints { make in
            make.edges.equalTo(self.qrCodeImageView)
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.qrCodeImageView.snp.top).inset(50)
            make.size.equalTo(31)
            make.centerX.equalTo(self.qrCodeImageView)
        }

        self.ticketStatusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.booltiLogoImageView)
            make.top.equalTo(self.booltiLogoImageView.snp.bottom).offset(11)
        }
    }

    func updateConstraintsForExpand() {
        self.qrCodeImageView.snp.updateConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(240)
        }

        self.booltiLogoImageView.snp.updateConstraints { make in
            make.top.equalTo(self.qrCodeImageView.snp.top).inset(80)
        }
    }

    func setData(with entity: TicketDetailInformation) {
        self.loadingIndicatorView.isLoading = true

        self.configureTicketStatus(with: entity)
        self.csTicketLabel.text = entity.csTicketID
        self.ticketNameLabel.text = entity.ticketName
        DispatchQueue.main.async {
            let qrCodeImage = QRMaker.shared.makeQR(identifier: entity.entryCode) ?? .qrCode
            self.qrCodeImageView.image = qrCodeImage
            self.loadingIndicatorView.isLoading = false
        }
    }

    private func configureTicketStatus(with entity: TicketDetailInformation) {
        switch entity.ticketStatus {
        case .concertEnd:
            self.ticketStatusLabel.text = "공연 종료"
            self.booltiLogoImageView.image = .booltiLogo
            self.ticketStatusLabel.textColor = .grey60
        case .notUsed:
            self.blurView.isHidden = true
            self.ticketStatusLabel.isHidden = true
            self.booltiLogoImageView.isHidden = true
        case .entryCompleted:
            self.ticketStatusLabel.text = "입장 완료"
            self.booltiLogoImageView.image = .orangeBooltiLogo
            self.ticketStatusLabel.textColor = .orange01
        }
    }
}
