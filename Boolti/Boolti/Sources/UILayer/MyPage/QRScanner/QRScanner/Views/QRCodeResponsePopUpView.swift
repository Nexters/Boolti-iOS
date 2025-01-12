//
//  QRCodeResponsePopUpView.swift
//  Boolti
//
//  Created by Miro on 2/26/24.
//

import UIKit

class QRCodeResponsePopUpView: UIView {
    
    private let entireBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 4
        
        return view
    }()
    
    private let toastBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("1B1D23").withAlphaComponent(0.8)
        view.layer.cornerRadius = 4
        
        return view
    }()

    private let iconImageView = UIImageView()

    private let toastMessageLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .white00

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: QRCodeValidationResponse) {
        self.iconImageView.image = item.iconImage
        self.toastMessageLabel.text = item.rawValue
        self.entireBorderView.layer.borderColor = item.statusColor.cgColor
    }

    private func configureUI() {
        self.addSubviews([
            self.entireBorderView,
            self.toastBackgroundView,
            self.iconImageView,
            self.toastMessageLabel
        ])

        self.configureConstraints()

    }

    private func configureConstraints() {
        self.entireBorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.toastBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }

        self.iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.toastBackgroundView)
            make.leading.equalTo(self.toastBackgroundView).inset(16)
        }

        self.toastMessageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.toastBackgroundView)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self.toastBackgroundView).inset(16)
        }
    }
}
