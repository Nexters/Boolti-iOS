//
//  UIStackView+.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
