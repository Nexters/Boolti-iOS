//
//  UIStackView+.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

extension UIStackView {

    func addArrangedSubViews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
