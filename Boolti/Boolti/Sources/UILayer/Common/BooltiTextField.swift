//
//  BooltiTextField.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

final class BooltiTextField: UITextField {

    // MARK: Init
    
    init(backgroundColor: UIColor = .grey85, withRightButton: Bool = false) {
        super.init(frame: .zero)
        self.configureUI(backgroundColor: backgroundColor)
        self.configureConstraints()
        
        if withRightButton { self.addRightPadding() }
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
    
    private func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
