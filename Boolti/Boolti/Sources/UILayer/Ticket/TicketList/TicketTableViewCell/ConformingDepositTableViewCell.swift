//
//  ConformingDepositTableViewCell.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit
import SnapKit

class ConformingDepositTableViewCell: UITableViewCell {

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey90
        view.clipsToBounds = true

        return view
    }()

    private lazy var mainStatementStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubViews([self.ticketIconImage, self.titleLabel, self.statusLabel])

        return stackView
    }()

    private let ticketIconImage: UIImageView = {
        let imageView = UIImageView(image: .ticketIcon)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey05
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "] 발권 대기 중"
        label.font = .subhead2
        label.textColor = .grey05
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return label
    }()

    private let navigateToDepositAccountButton: UIButton = {
        let button = UIButton()
        button.setImage(.navigate, for: .normal)
        button.setTitle("입금 계좌 보러 가기", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func configureUI() {
        self.contentView.addSubviews([
            self.upperTagView,
            self.mainStatementStackView,
            self.navigateToDepositAccountButton
        ])

        self.configureBorder()
        self.configureConstraints()
    }

    func configure(with id: Int, title: String) {
        self.titleLabel.text = "[\(title)"
    }

    private func configureBorder(){
//        let borderLayer = CAShapeLayer()
//
//        borderLayer.strokeColor = UIColor.grey80.cgColor
//        borderLayer.lineDashPattern = [2, 2]
//        borderLayer.frame = self.contentView.bounds
//        borderLayer.fillColor = nil
//        borderLayer.path = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: 8).cgPath
//
//        self.contentView.layer.addSublayer(borderLayer)
    }

    private func configureConstraints() {

        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(142)
        }

        self.upperTagView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(32)
        }

        self.mainStatementStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
        }

        self.navigateToDepositAccountButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-8)
            make.left.equalTo(self.mainStatementStackView)
        }
    }
}
