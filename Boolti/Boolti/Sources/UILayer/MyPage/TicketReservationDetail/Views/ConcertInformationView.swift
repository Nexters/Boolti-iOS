//
//  ConcertInformationView.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

final class ConcertInformationView: UIView {

    private let concertPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey50.cgColor
        imageView.clipsToBounds = true

        return imageView
    }()

    private let concertTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroB(20)
        label.textColor = .grey05
        label.numberOfLines = 3

        return label
    }()

    private let ticketInformationLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30

        return label
    }()

    private lazy var informationVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        stackView.addArrangedSubviews([
            self.concertTitleLabel,
            self.ticketInformationLabel
        ])

        return stackView
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setData(posterImageURLPath: String, concertTitle: String, salesTicketName: String, ticketCount: String ) {
        self.concertPosterImageView.setImage(with: posterImageURLPath)
        self.concertTitleLabel.text = concertTitle
        self.ticketInformationLabel.text = "\(salesTicketName) / \(ticketCount) 매"
    }

    private func configureUI() {
        self.addSubviews([
            self.concertPosterImageView,
            self.informationVerticalStackView
        ])

        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenWidth = window.screen.bounds.width

        self.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(screenWidth)
        }

        self.concertPosterImageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(98)
            make.centerY.equalToSuperview().offset(-5)
            make.left.equalToSuperview().inset(20)
        }
        
        self.informationVerticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.concertPosterImageView)
            make.left.equalTo(self.concertPosterImageView.snp.right).offset(16)
        }
    }
}
