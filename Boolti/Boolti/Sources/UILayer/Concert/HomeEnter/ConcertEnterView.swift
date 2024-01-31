//
//  ConcertEnterView.swift
//  Boolti
//
//  Created by Miro on 1/30/24.
//

import UIKit

final class ConcertEnterView: UIView {

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 구매한 티켓이 없어요"
        label.font = .headline1
        label.textColor = .grey05

        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓을 구매하고 공연을 즐겨보세요!"
        label.textColor = .grey30
        label.font = .body3

        return label
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .popupBackground)

        return imageView
    }()


    let navigateToHomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("공연 탐색하기", for: .normal)
        button.titleLabel?.font = .subhead1
        button.titleLabel?.textColor = .grey05
        button.layer.cornerRadius = 4
        button.backgroundColor = .orange01

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {

        self.addSubviews([
            self.backgroundImageView,
            self.headerTitleLabel,
            self.subTitleLabel,
            self.navigateToHomeButton
        ])

        self.backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.headerTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.backgroundImageView)
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.backgroundImageView)
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(4)
        }

        self.navigateToHomeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.backgroundImageView)
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(30)
            make.width.equalTo(130)
            make.height.equalTo(50)
        }
    }
}
