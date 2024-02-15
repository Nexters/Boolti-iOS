//
//  UITextView+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import UIKit

extension UITextView {

    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let attributedText = self.attributedText, let font = self.font, let textColor = self.textColor {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.lineBreakStrategy = .hangulWordPriority

            mutableAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, mutableAttributedText.length))
            mutableAttributedText.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, mutableAttributedText.length))
            mutableAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, mutableAttributedText.length))

            self.attributedText = mutableAttributedText
        }
    }
}
