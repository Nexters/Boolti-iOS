//
//  MypageContentView.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MypageContentView: UIView {

    private let disposeBag = DisposeBag()
    
    private let iconImageView = UIImageView()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    init(icon: UIImage, title: String) {
        super.init(frame: .zero)
        self.iconImageView.image = icon.withTintColor(.grey30, renderingMode: .alwaysOriginal)
        self.titleLabel.text = title
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubviews([
            self.iconImageView,
            self.titleLabel
        ])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(24)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(12)
        }
    }
}
