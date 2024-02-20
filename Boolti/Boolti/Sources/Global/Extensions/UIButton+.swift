//
//  UIButton+.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit

extension UIButton {

    func setUnderline(font: UIFont, textColor: UIColor) {
        guard let title = self.title(for: .normal) else { return }
        let range = NSRange(location: 0, length: title.count)
        let attributedString = NSMutableAttributedString(string: title)

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range
        )
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)

        self.setAttributedTitle(attributedString, for: .normal)
    }
}
