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
                return "예매 마감"
            case .endConcert:
                return "공연 종료"
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .beforeSale: .grey05
            default: .grey40
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .beforeSale: .orange01
            default: .grey80
            }
        }
        
        var backgroundAlpha: CGFloat {
            switch self {
            case .onSale: 1
            default: 0.5
            }
        }
        
        var isHidden: Bool {
            switch self {
                case .onSale: true
                default: false
            }
        }

    }
    
    private var concertState: ConcertState = .onSale
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey70
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey80.cgColor
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
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let stateLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: .init(top: 7, left: 12, bottom: 7, right: 12))
        label.font = .caption
        label.layer.cornerRadius = 15
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
        
        if Date().compare(concertEntity.salesStartTime) == .orderedAscending {
            self.concertState = .beforeSale(startSale: concertEntity.salesStartTime)
        }
        else if Date().compare(concertEntity.salesEndTime) == .orderedAscending {
            self.concertState = .onSale
        }
        else if Date().compare(concertEntity.dateTime.addingTimeInterval(60 * 300)) == .orderedAscending {
            self.concertState = .endSale
        }
        else {
            self.concertState = .endConcert
        }
        
        self.stateLabel.text = self.concertState.text
        self.stateLabel.textColor = self.concertState.fontColor
        self.stateLabel.isHidden = self.concertState.isHidden
        self.stateLabel.backgroundColor = self.concertState.backgroundColor
        self.posterImageView.alpha = self.concertState.backgroundAlpha
    }
    
    private func resetData() {
        self.posterImageView.image = nil
        self.datetime.text = nil
        self.name.text = nil
        self.stateLabel.isHidden = true
    }
}

// MARK: - UI

extension ConcertCollectionViewCell {
    
    private func configureUI() {
        self.addSubviews([self.posterImageView,
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
