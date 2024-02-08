//
//  ConcertInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit
import RxSwift
import SnapKit

final class ConcertInfoView: UIView {
    
    // MARK: UI Component
    
    private let poster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey30
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.alignment = .fill
        
        view.addArrangedSubviews([self.titleLabel, self.datetimeLabel])
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .point2
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .grey05
        return label
    }()
    
    private let datetimeLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
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

extension ConcertInfoView {
    
    func setData(posterURL: String, title: String, datetime: Date) {
        self.poster.setImage(with: posterURL)
        self.titleLabel.text = title
        self.titleLabel.setLineSpacing(lineSpacing: 6)
        self.datetimeLabel.text = datetime.format(.dateTime)
    }
}

// MARK: - UI

extension ConcertInfoView {
    
    private func configureUI() {
        self.addSubviews([self.poster, self.labelStackView])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(126)
        }
        
        self.poster.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.poster)
            make.left.equalTo(self.poster.snp.right).offset(16)
            make.right.equalToSuperview().inset(20)
        }
    }
}
