//
//  CastTeamListCollectionViewCell.swift
//  Boolti
//
//  Created by Miro on 10/3/24.
//

import UIKit

import SnapKit

final class CastTeamListCollectionViewCell: UICollectionViewCell {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .grey80
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.grey80.cgColor
        imageView.image = .defaultProfile

        return imageView
    }()

    private let profileNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey10

        return label
    }()

    private let roleNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey50

        return label
    }()

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubviews([self.profileNameLabel,self.roleNameLabel])
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileNameLabel.text = ""
        self.profileImageView.image = nil
        self.roleNameLabel.text = ""
    }

    func configure(with entity: TeamMember) {
        self.profileNameLabel.text = entity.nickName
        self.roleNameLabel.text = entity.roleName
        self.profileImageView.setImage(with: entity.imagePath)
    }

    private func configureUI() {
        self.contentView.addSubviews([
            self.profileImageView,
            self.profileStackView
        ])

        self.profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(self.profileStackView)
            make.width.equalTo(self.profileImageView.snp.height)
        }

        self.profileStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
}
