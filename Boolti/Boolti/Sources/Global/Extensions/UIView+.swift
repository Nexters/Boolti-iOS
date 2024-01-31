//
//  UIView+.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
