//
//  ButtonTextField.swift
//  Boolti
//
//  Created by Miro on 9/6/24.
//
import UIKit

import RxCocoa

final class ButtonTextField: BooltiTextField {

    var isButtonHidden = true {
        didSet {
            self.button.isHidden = isButtonHidden
        }
    }

    var didButtonTap: ControlEvent<Void> {
        return self.button.rx.tap
    }

    private let button: UIButton = {
        let button = UIButton()
        return button
    }()

    init(with image: UIImage, placeHolder: String) {
        super.init(withRightButton: true)
        super.setPlaceHolderText(placeholder: placeHolder)
        self.button.setImage(image, for: .normal)
        self.button.isHidden = true

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
