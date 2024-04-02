//
//  ReservedTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

final class ReservedTicketView: UIView {
    
    // MARK: UI Component
    
    private let poster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey30
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .fill
        
        view.addArrangedSubviews([self.titleLabel, self.ticketDetailLabel, self.priceLabel])
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point1
        label.numberOfLines = 2
        label.textColor = .grey05
        return label
    }()
    
    private let ticketDetailLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey30
        return label
    }()
    
    private let priceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey30
        return label
    }()

    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension ReservedTicketView {
    
    func setData(concert: ConcertDetailEntity, selectedTicket: SelectedTicketEntity) {
        self.titleLabel.text = concert.name
        self.ticketDetailLabel.text = "\(selectedTicket.ticketName) / \(selectedTicket.count)매"
        self.priceLabel.text = "\((selectedTicket.count * selectedTicket.price).formattedCurrency())원"
        self.poster.setImage(with: concert.posters.first?.thumbnailPath ?? "")
    }
}


// MARK: - UI

extension ReservedTicketView {
    
    private func configureUI() {
        self.addSubviews([self.poster, self.labelStackView])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(146)
        }
        
        self.poster.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(98)
            make.width.equalTo(70)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.poster.snp.right).offset(16)
            make.right.equalToSuperview().inset(20)
        }
    }
}
