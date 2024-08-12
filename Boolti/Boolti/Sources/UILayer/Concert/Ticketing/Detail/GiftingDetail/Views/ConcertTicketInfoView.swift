//
//  ConcertTicketInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/9/24.
//

import UIKit

final class ConcertTicketInfoView: UIView {

    // MARK: UI Components
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "공연 및 티켓 정보"
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey30
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        return view
    }()
    
    private let concertTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point1
        label.numberOfLines = 2
        label.textColor = .grey15
        return label
    }()
    
    private let datetimeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private lazy var concertInfoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.alignment = .fill
        
        view.addArrangedSubviews([self.concertTitleLabel,
                                  self.datetimeLabel])
        return view
    }()
    
    private lazy var ticketTypeTitleLabel = self.makeSelectedTitleLabel(title: "티켓 종류")
    private lazy var ticketTypeDataLabel = self.makeSelectedDataLabel()
    private lazy var ticketTypeStackView = self.makeStackView(with: [ticketTypeTitleLabel, ticketTypeDataLabel])
    
    private lazy var ticketCountTitleLabel = self.makeSelectedTitleLabel(title: "티켓 매수")
    private lazy var ticketCountDataLabel = self.makeSelectedDataLabel()
    private lazy var ticketCountStackView = self.makeStackView(with: [ticketCountTitleLabel, ticketCountDataLabel])
    
    private lazy var totalPriceTitleLabel = self.makeSelectedTitleLabel(title: "총 결제 금액")
    private lazy var totalPriceDataLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline1
        label.textColor = .orange01
        label.textAlignment = .right
        return label
    }()
    private lazy var totalPriceStackView = self.makeStackView(with: [self.totalPriceTitleLabel,
                                                                     self.totalPriceDataLabel])
    private lazy var ticketInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 16
        
        view.addArrangedSubviews([self.ticketTypeStackView,
                                  self.ticketCountStackView,
                                  self.totalPriceStackView])
        return view
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Methods

extension ConcertTicketInfoView {
    
    private func makeSelectedTitleLabel(title: String) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        label.text = title
        return label
    }
    
    private func makeSelectedDataLabel() -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey15
        label.textAlignment = .right
        return label
    }
    
    private func makeStackView(with labels: [UILabel]) -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.addArrangedSubviews(labels)
        return view
    }
    
    func setData(posterURL: String,
                 title: String,
                 datetime: Date,
                 ticketInfo: SelectedTicketEntity) {
        self.posterImageView.setImage(with: posterURL)
        self.concertTitleLabel.text = title
        self.datetimeLabel.text = datetime.format(.dateDayTime)
        self.ticketTypeDataLabel.text = ticketInfo.ticketName
        self.ticketCountDataLabel.text = "\(ticketInfo.count)매"
        self.totalPriceDataLabel.text = "\((ticketInfo.count * ticketInfo.price).formattedCurrency())원"
    }
    
}

// MARK: - UI

extension ConcertTicketInfoView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        
        self.addSubviews([self.titleLabel,
                          self.posterImageView,
                          self.concertInfoStackView,
                          self.ticketInfoStackView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(328)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.width.equalTo(70)
            make.height.equalTo(98)
        }
        
        self.concertInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.posterImageView)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.ticketInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
