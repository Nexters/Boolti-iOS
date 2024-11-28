//
//  PlaceInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

import RxSwift
import RxCocoa

final class PlaceInfoView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.text = "장소"
        label.textColor = .grey10
        label.font = .subhead2
        
        return label
    }()
    
    private let copyButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "주소복사"
        config.attributedTitle?.font = .pretendardR(12)
        config.background.backgroundColor = .grey85
        config.baseForegroundColor = .grey05
        config.background.cornerRadius = 4
        config.imagePadding = 6
        
        let button = UIButton(configuration: config)
        button.setImage(.copy, for: .normal)

        return button
    }()

    
    private let placeNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .body3
        
        return label
    }()
    
    let addressLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        
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
        fatalError()
    }
}

// MARK: - Methods

extension PlaceInfoView {
    
    func setData(name: String, streetAddress: String, detailAddress: String) {
        self.placeNameLabel.text = name
        self.addressLabel.text = "\(streetAddress) / \(detailAddress)"
    }
    
    func didAddressCopyButtonTap() -> Signal<Void> {
        return self.copyButton.rx.tap.asSignal()
    }
}

// MARK: - UI

extension PlaceInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.copyButton, self.placeNameLabel, self.addressLabel, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.copyButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self.titleLabel)
        }
        
        self.placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.titleLabel)
        }
        
        self.addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self.placeNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self.placeNameLabel)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.addressLabel)
        }
    }
}

