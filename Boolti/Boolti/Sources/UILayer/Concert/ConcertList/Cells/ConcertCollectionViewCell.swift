//
//  ConcertCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/9/24.
//

import UIKit

final class ConcertCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    enum ConcertState {
        
        case beforeSale(startSale: Date)
        case onSale
        case endSale
        case endConcert
        
        var text: String {
            switch self {
            case .beforeSale(let startSale):
                return "예매 시작 D-\(Date().getBetweenDay(to: startSale))"
            case .onSale:
                return "예매 중"
            case .endSale:
                return "예매 종료"
            case .endConcert:
                return "공연 종료"
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .beforeSale: .orange01
            case .onSale: .grey05
            case .endSale: .grey80
            case .endConcert: .grey40
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .beforeSale: .grey80.withAlphaComponent(0.9)
            case .onSale: .orange01.withAlphaComponent(0.9)
            case .endSale: .grey20.withAlphaComponent(0.9)
            case .endConcert: .grey80.withAlphaComponent(0.9)
            }
        }
        
        var backgroundAlpha: CGFloat {
            switch self {
            case .onSale, .endSale, .endConcert: 1
            case .beforeSale: 0.4
            }
        }
    }
    
    private var concertState: ConcertState = .onSale
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey70
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey80.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.grey95.withAlphaComponent(0.2).cgColor,
                                UIColor.grey95.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.6, 0.8, 1.0]
        imageView.layer.addSublayer(gradientLayer)
        return imageView
    }()
    
    private let datetime: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private let name: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point1
        label.textColor = .grey05
        label.numberOfLines = 2
        return label
    }()
    
    private let stateLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: .init(top: 5, left: 12, bottom: 5, right: 12))
        label.font = .caption
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gradientLayer = self.posterImageView.layer.sublayers?.first else { return }
        gradientLayer.frame = self.posterImageView.bounds
    }
    
    override func prepareForReuse() {
        self.resetData()
    }
}

// MARK: - Methods

extension ConcertCollectionViewCell {
    
    func setData(concertEntity: ConcertEntity) {
        self.posterImageView.setImage(with: concertEntity.posterPath)
        self.datetime.text = concertEntity.dateTime.format(.dateDayTime)
        self.name.text = concertEntity.name
        
        if Date() < concertEntity.salesStartTime {
            self.concertState = .beforeSale(startSale: concertEntity.salesStartTime)
        }
        else if Date() <= concertEntity.salesEndTime {
            self.concertState = .onSale
        }
        else if Date().getBetweenDay(to: concertEntity.dateTime) >= 0 {
            self.concertState = .endSale
        }
        else {
            self.concertState = .endConcert
        }
        
        self.stateLabel.text = self.concertState.text
        self.stateLabel.textColor = self.concertState.fontColor
        self.stateLabel.backgroundColor = self.concertState.backgroundColor
        self.posterImageView.alpha = self.concertState.backgroundAlpha
    }
    
    private func resetData() {
        self.posterImageView.image = nil
        self.datetime.text = nil
        self.name.text = nil
    }
}

// MARK: - UI

extension ConcertCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubviews([self.posterImageView,
                          self.stateLabel,
                          self.datetime,
                          self.name])
    }
    
    private func configureConstraints() {
        self.posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(1.406)
        }
        
        self.stateLabel.snp.makeConstraints { make in
            make.bottom.right.equalTo(self.posterImageView).inset(10)
        }
        
        self.datetime.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.name.snp.makeConstraints { make in
            make.top.equalTo(self.datetime.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
