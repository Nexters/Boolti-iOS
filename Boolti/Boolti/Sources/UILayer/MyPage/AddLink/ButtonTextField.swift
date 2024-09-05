//
//  ButtonTextField.swift
//  Boolti
//
//  Created by Miro on 9/6/24.
//

import UIKit

final class ButtonTextField: BooltiTextField {

    var isButtonHidden = true {
        didSet {
            self.button.isHidden = isButtonHidden
        }
    }

    private let button: UIButton = {
        let button = UIButton()
        return button
    }()

    init(with image: UIImage, placeHolder: String) {
        super.init(withRightButton: true)
        super.setPlaceHolderText(placeholder: placeHolder)
        self.button.setImage(image, for: .normal)

        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(self.button)

        self.button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    }
}
