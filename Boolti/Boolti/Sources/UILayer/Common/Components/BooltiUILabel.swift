//
//  BooltiUILabel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/17/24.
//

import UIKit

final class BooltiUILabel: UILabel {

    override var text: String? {
        didSet {
            self.setLineHeight()
        }
    }
}
