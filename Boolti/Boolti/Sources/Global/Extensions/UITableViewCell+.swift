//
//  UITableViewCell+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

extension UITableViewCell {

    static var className: String {
        return String(describing: Self.self)
    }
}
