//
//  BooltiTextField.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

final class BooltiTextField: UITextField {
    
    // MARK: UI Component
    
    var searchButton: UIButton?

    // MARK: Init
    
    init(backgroundColor: UIColor = .grey85, isSearchBar: Bool = false) {
        super.init(frame: .zero)
        self.configureUI(backgroundColor: backgroundColor)
        self.configureConstraints()
        
        if isSearchBar { self.addSearchButton() }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension BooltiTextField {
    
    func setPlaceHolderText(placeholder: String, foregroundColor: UIColor = UIColor.grey70) {
        self.placeholder = placeholder
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [.foregroundColor: foregroundColor,
                                                                     .font: UIFont.body3])
    }
}

// MARK: - UI

extension BooltiTextField {
    
    private func configureUI(backgroundColor: UIColor) {
        self.layer.cornerRadius = 4
        self.font = .body3
        self.textColor = .grey15
        self.backgroundColor = backgroundColor

        self.addLeftPadding()
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    private func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    private func addSearchButton() {
        self.searchButton = {
            let button = UIButton()
            button.setImage(.search, for: .normal)
            return button
        }()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: self.frame.height))
        paddingView.addSubview(self.searchButton ?? UIButton())
        
        self.searchButton?.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(paddingView)
            make.height.width.equalTo(24)
        }
        
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
