//
//  ConfirmingDepositTableViewCell.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit
import SnapKit

class ConfirmingDepositTableViewCell: UITableViewCell {

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey90

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

    private var navigateToDepositAccountButton: UIButton = {
        let button = UIButton()
        button.setImage(.navigate, for: .normal)
        button.setTitle("입금 계좌 보러 가기", for: .normal)
        button.titleLabel?.textColor = .grey30
        button.semanticContentAttribute = .forceRightToLeft

        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        )
    }

    func setData(with id: Int, title: String) {
        self.titleLabel.text = " [\(title)"
        self.configureUI()
    }

    private func configureUI() {
        self.backgroundColor = .grey95

        self.contentView.backgroundColor = .grey95
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true

        self.contentView.addSubviews([
            self.upperTagView,
            self.mainStatementStackView,
            self.navigateToDepositAccountButton
        ])

        self.configureBorder()
        self.configureConstraints()
    }

    private func configureBorder(){
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = UIColor.grey80.cgColor
        borderLayer.lineWidth = 3
        borderLayer.lineDashPattern = [3, 3]
        borderLayer.fillColor = nil
        let bounds = self.contentView.bounds
        let borderRect = CGRect(x: bounds.origin.x, y: bounds.origin.x, width: bounds.width, height: bounds.height-20)
        borderLayer.path = UIBezierPath(roundedRect: borderRect, cornerRadius: 8).cgPath

        self.contentView.layer.addSublayer(borderLayer)
    }

    private func configureConstraints() {

        self.upperTagView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(32)
        }

        self.mainStatementStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.lessThanOrEqualToSuperview().inset(20)
            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
        }

        self.navigateToDepositAccountButton.snp.makeConstraints { make in
            make.top.equalTo(self.mainStatementStackView.snp.bottom).offset(8)
            make.left.equalTo(self.mainStatementStackView)
        }
    }
}
