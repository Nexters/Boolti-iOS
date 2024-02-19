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
        label.lineBreakMode = .byWordWrapping
        
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
        self.datetimeLabel.text = "\(date.format(.dateDayTimeWithSlash)) (\(runningTime)분)"
        
        self.snp.makeConstraints { make in
            make.height.equalTo(114 + self.datetimeLabel.getLabelHeight())
        }
    }
}

// MARK: - UI

extension DatetimeInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.datetimeLabel, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.titleLabel)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.datetimeLabel)
        }
    }
}
