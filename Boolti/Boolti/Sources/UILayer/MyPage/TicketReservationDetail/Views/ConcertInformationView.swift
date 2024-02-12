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
        imageView.layer.cornerRadius = 4
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey50.cgColor
        imageView.clipsToBounds = true
        imageView.image = .mockPoster

        return imageView
    }()

    private let concertTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .aggroB(20)
        label.textColor = .grey05
        label.text = "2024 TOGETHER LUCKY CLUB"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 4)

        return label
    }()

    private let ticketInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30
        label.text = "일반 티켓 B / 1매"

        return label
    }()

    private lazy var informationVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6

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
        fatalError("init(coder:) has not been implemented")
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
            make.height.equalTo(120)
            make.width.equalTo(screenWidth)
        }

        self.concertPosterImageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(98)
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-3)
        }
        
        self.concertTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(249)
        }

        self.informationVerticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.concertPosterImageView)
            make.left.equalTo(self.concertPosterImageView.snp.right).offset(16)
        }
    }
}
