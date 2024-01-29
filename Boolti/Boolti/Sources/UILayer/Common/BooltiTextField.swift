//
//  BooltiTextField.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

final class BooltiTextField: UITextField {

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension BooltiTextField {
    
    func setPlaceHolderText(placeholder: String) {
        self.placeholder = placeholder
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [.foregroundColor: UIColor.grey70,
                                                                     .font: UIFont.body3])
    }
}

// MARK: - UI

extension BooltiTextField {
    
    private func configureUI() {
        self.layer.cornerRadius = 4
        self.font = .body3
        self.textColor = .grey15
        self.backgroundColor = .grey85
    }
}
