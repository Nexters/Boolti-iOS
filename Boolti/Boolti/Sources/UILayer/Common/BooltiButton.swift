//
//  BooltiButton.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit
import SnapKit

final class BooltiButton: UIButton {

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead1
        return label
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.configureUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var isEnabled: Bool {
        didSet {
            self.setButtonUI()
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        self.mainTitleLabel.text = title
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        self.mainTitleLabel.textColor = color
    }

    private func configureUI(title: String) {
        self.addSubview(self.mainTitleLabel)

        self.mainTitleLabel.text = title
        self.layer.cornerRadius = 4
        self.configureConstraints()
        self.setButtonUI()
    }

    private func configureConstraints() {

        self.mainTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            
            // 대부분의 버튼이 height 48
            make.height.equalTo(48)
        }
    }
    
    private func setButtonUI() {
        if isEnabled {
            self.backgroundColor = .orange01
            self.mainTitleLabel.textColor = .white00
        } else {
            self.backgroundColor = .grey80
            self.mainTitleLabel.textColor = .grey50
        }
    }
}

