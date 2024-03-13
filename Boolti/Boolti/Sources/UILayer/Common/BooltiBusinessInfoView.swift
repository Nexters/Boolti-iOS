//
//  BooltiBusinessInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/11/24.
//

import UIKit
import SnapKit

final class BooltiBusinessInfoView: UIView {
    
    // MARK: UI Component
    
    private let infoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "스튜디오 불티 사업자 정보"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey70
        config.contentInsets = .init(top: 3, leading: 0, bottom: 3, trailing: 0)

        let button = UIButton(configuration: config)
        button.setImage(.chevronRight, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft

        return button
    }()
    
    private let copyrightLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey70
        label.text = "ⓒ Boolti. All Rights Reserved"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.addArrangedSubviews([self.infoButton, self.copyrightLabel])
        return stackView
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: UI

extension BooltiBusinessInfoView {

    private func configureUI() {
        self.addSubview(self.labelStackView)
    }

    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(86)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
