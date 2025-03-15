//
//  DatetimePlaceInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

final class DatetimePlaceInfoView: UIView {
    
    // MARK: UI Component
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .clock
        return imageView
    }()
    
    private let datetimeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        
        return label
    }()

    private let runningTimeLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: .init(top: 3, left: 8, bottom: 3, right: 8))
        label.font = .caption
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .grey50
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.grey50.cgColor
        return label
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .placePin
        return imageView
    }()
    
    private let placeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension DatetimePlaceInfoView {
    
    func setData(date: Date, runningTime: Int, placeName: String) {
        self.datetimeLabel.text = "\(date.format(.dateDayTimeWithSlash))"
        self.runningTimeLabel.text = "\(runningTime)분"
        self.placeLabel.text = placeName
    }
}

// MARK: - UI

extension DatetimePlaceInfoView {
    
    private func configureUI() {
        self.addSubviews([self.clockImageView,
                          self.datetimeLabel,
                          self.runningTimeLabel,
                          self.pinImageView,
                          self.placeLabel])
    }
    
    private func configureConstraints() {
        self.clockImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.datetimeLabel)
            make.size.equalTo(20)
            make.leading.equalToSuperview()
        }
        
        self.datetimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.clockImageView.snp.trailing).offset(6)
        }

        self.runningTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(self.datetimeLabel.snp.right).offset(6)
            make.centerY.equalTo(self.clockImageView.snp.centerY)
        }
        
        self.pinImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.placeLabel)
            make.size.equalTo(20)
            make.leading.equalToSuperview()
        }
        
        self.placeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.datetimeLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.pinImageView.snp.trailing).offset(6)
            make.bottom.equalToSuperview()
        }
    }
}
