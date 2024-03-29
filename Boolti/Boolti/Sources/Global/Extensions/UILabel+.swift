//
//  UILabel+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

extension UILabel {

    private func getFontLineHeight(font: UIFont) -> CGFloat {
        switch self.font {
        case UIFont.caption:
            return self.font.pointSize + 6
        default:
            return self.font.pointSize + 8
        }
    }
    
    // label의 height 조절
    func setLineHeight() {
        if let text = self.text {
            let lineHeight: CGFloat = self.getFontLineHeight(font: self.font)
            
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            style.lineBreakMode = .byTruncatingTail
            style.lineBreakStrategy = .hangulWordPriority
            
            let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 2
            ]
            
            let attributeString = NSAttributedString(string: text,
                                                     attributes: attributes)
            self.attributedText = attributeString
        }
    }
    
    /// 행간 + headIndent 조정 메서드 (정책에서 쓰임)
    func setHeadIndent() {
        if let existingAttributedString = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: existingAttributedString)
            let style = NSMutableParagraphStyle()
            
            let lineHeight: CGFloat = self.getFontLineHeight(font: self.font)
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            style.lineBreakStrategy = .hangulWordPriority
            style.headIndent = 10
            attributedString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
        }
    }

    /// 여러 줄일 때 정렬
    func setAlignment(_ alignment: NSTextAlignment) {
        if let existingAttributedString = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: existingAttributedString)
            let style = NSMutableParagraphStyle()
            
            let lineHeight: CGFloat = self.getFontLineHeight(font: self.font)
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            style.lineBreakMode = .byTruncatingTail
            style.lineBreakStrategy = .hangulWordPriority
            style.alignment = alignment
            attributedString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
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
            
            self.attributedText = attributedString
        }
    }
    
    /// 현재 label의 전체 높이를 반환하는 함수
    func getLabelHeight() -> CGFloat {
        return self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    /// 특정 label에 under line 넣는 함수
    func setUnderLine(to targetString: String) {
        if let existingAttributedString = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: existingAttributedString)
            let linkAttributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            attributedString.addAttributes(
                linkAttributes,
                range: (attributedString.string as NSString).range(of: targetString)
            )
            
            attributedText = attributedString
        }
    }
    
    /// 라벨 내 특정 문자열의 CGRect 반환
    /// - Parameter subText: CGRect값을 알고 싶은 특정 문자열
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text else { return nil }
        
        // 전체 텍스트(text)에서 subText만큼의 range를 구합니다.
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)
        
        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )
        
        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}
