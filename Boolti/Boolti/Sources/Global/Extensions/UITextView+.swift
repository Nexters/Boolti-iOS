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

            mutableAttributedText
                .addAttributes([.paragraphStyle: style,
                                                 .font: font,
                                                 .foregroundColor: textColor],
                               range: NSMakeRange(0, mutableAttributedText.length))

            self.attributedText = mutableAttributedText
        }
    }
    
    /// 현재 textView의 전체 높이를 반환하는 함수
    func getTextViewHeight() -> CGFloat {
        return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
}
