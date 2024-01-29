//
//  UIStackView+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
