//
//  CastTeamListHeaderView.swift
//  Boolti
//
//  Created by Miro on 10/6/24.
//

import UIKit

import SnapKit

final class CastTeamListHeaderView: UICollectionReusableView {

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()

    func configure(with title: String) {
        self.headerTitleLabel.text = title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.headerTitleLabel.text = ""
    }

    private func configureUI() {
        self.addSubview(headerTitleLabel)

        self.headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }

}
