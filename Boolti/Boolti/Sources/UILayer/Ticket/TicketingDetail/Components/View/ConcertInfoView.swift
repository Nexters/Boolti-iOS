//
//  ConcertInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit
import SnapKit
import RxSwift

final class ConcertInfoView: UIView {
    
    // MARK: UI Component
    
    private let poster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey30
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .aggroB
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
    
    func setData(posterURL: String, title: String, datetime: String) {
        self.poster.setImageUrl(posterURL)
        self.titleLabel.text = title
        self.titleLabel.setLineSpacing(lineSpacing: 6)
        self.datetimeLabel.text = datetime
    }
}

// MARK: - UI

extension ConcertInfoView {
    
    private func configureUI() {
        self.addSubviews([poster, labelStackView])
        self.labelStackView.addArrangedSubviews([titleLabel, datetimeLabel])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(138)
        }
        
        self.poster.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(20)
            make.width.equalTo(70)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.poster.snp.right).offset(16)
            make.right.equalToSuperview().inset(20)
        }
    }
}