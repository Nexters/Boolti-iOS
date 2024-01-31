//
//  UILabel+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

extension UILabel {
    
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    /// 특정 문자열 컬러 변경하는 메서드
    func setSubStringColor(to targetString: [String], with color: UIColor) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            targetString.forEach { string in
                attributedString.addAttribute(
                    .foregroundColor,
                    value: color,
                    range: (labelText as NSString).range(of: string)
                )
            }
            
            attributedText = attributedString
        }
    }
}
