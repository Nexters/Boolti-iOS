//
//  DatetimeInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

final class DatetimeInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .subhead2
        label.text = "일시"
        
        return label
    }()
    
    private let datetimeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        
        return label
    }()

    private let runningTimeLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: .init(top: 5, left: 12, bottom: 5, right: 12))
        label.font = .caption
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textColor = .grey50
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.grey50.cgColor
        return label
    }()

    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey85
        
        return view
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

extension DatetimeInfoView {
    
    func setData(date: Date, runningTime: Int) {
        self.datetimeLabel.text = "\(date.format(.dateDayTimeWithSlash))"
        self.runningTimeLabel.text = "\(runningTime)분"
    }
}

// MARK: - UI

extension DatetimeInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.datetimeLabel, self.runningTimeLabel, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.titleLabel.snp.left)
        }

        self.runningTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(self.datetimeLabel.snp.right).offset(6)
            make.centerY.equalTo(self.datetimeLabel.snp.centerY)
        }

        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(self.runningTimeLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
