//
//  MypageContentView.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxSwift
import RxCocoa

class MypageContentView: UIView {

    private let disposeBag = DisposeBag()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardB(18)
        label.textColor = .grey10

        return label
    }()

    private let navigateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .navigate

        return imageView
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .grey90

        self.addSubviews([
            self.titleLabel,
            self.navigateImageView
        ])

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }

        self.navigateImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }
}
