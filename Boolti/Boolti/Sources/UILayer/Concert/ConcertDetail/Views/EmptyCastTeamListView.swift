//
//  EmptyCastTeamListView.swift
//  Boolti
//
//  Created by Miro on 10/8/24.
//

import UIKit
import SnapKit

final class EmptyCastTeamListView: UIView {

    private let headTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "COMING SOON"
        label.font = .aggroM(20)
        label.textColor = .grey20

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조금만 기다려주세요!"
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([self.headTitleLabel, self.subtitleLabel])
        stackView.spacing = 4
        stackView.alignment = .center

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(self.stackView)

        self.snp.makeConstraints { make in
            make.height.equalTo(290)
        }

        self.stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    

}
