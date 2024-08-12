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
    
    // lineHeight 조정 메서드
    func setLineHeight(alignment: NSTextAlignment) {
        guard let text = self.text, let font = self.font, let color = self.textColor else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(
            .font,
            value: font,
            range: (text as NSString).range(of: text)
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: (text as NSString).range(of: text)
        )
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        paragraphStyle.alignment = alignment
        
        switch font {
        case .caption:
            paragraphStyle.minimumLineHeight = font.pointSize + 6
            paragraphStyle.maximumLineHeight = font.pointSize + 6
        default:
            paragraphStyle.minimumLineHeight = font.pointSize + 8
            paragraphStyle.maximumLineHeight = font.pointSize + 8
        }
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        switch font {
        case .caption:
            attributedString.addAttribute(.baselineOffset, value: (font.pointSize + 6 - font.lineHeight) / 2,
                                          range: NSRange(location: 0, length: attributedString.length))
        default:
            attributedString.addAttribute(.baselineOffset, value: (font.pointSize + 8 - font.lineHeight) / 2,
                                          range: NSRange(location: 0, length: attributedString.length))
        }
        
        self.attributedText = attributedString
    }
    
}
