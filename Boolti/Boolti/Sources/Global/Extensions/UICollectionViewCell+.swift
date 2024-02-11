//
//  UICollectionViewCell+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/11/24.
//

import UIKit

extension UICollectionViewCell {

    static var className: String {
        return String(describing: Self.self)
    }
}
