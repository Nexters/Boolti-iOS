//
//  ConcertEnterView.swift
//  Boolti
//
//  Created by Miro on 1/30/24.
//

import UIKit

final class ConcertEnterView: UIView {

    private let headerTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.text = "아직 발권된 티켓이 없어요"
        label.font = .headline1
        label.textColor = .grey05

        return label
    }()

    private let subTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.text = "티켓을 예매하고 공연을 즐겨보세요!"
        label.textColor = .grey30
        label.font = .body3

        return label
    }()

    private let topBackgroundImageView = UIImageView(image: .popupBackground)
    private let bottomBackgroundImageView = UIImageView(image: .popupBackground)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .grey95

        self.addSubviews([
            self.topBackgroundImageView,
            self.headerTitleLabel,
            self.subTitleLabel,
            self.bottomBackgroundImageView
        ])

        self.topBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(575)
        }

        self.headerTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.topBackgroundImageView)
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.topBackgroundImageView)
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(4)
        }
        
        self.bottomBackgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(self.topBackgroundImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
