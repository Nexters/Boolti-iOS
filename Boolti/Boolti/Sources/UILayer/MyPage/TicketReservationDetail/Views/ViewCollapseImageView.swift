//
//  ViewCollapseImageView.swift
//  Boolti
//
//  Created by Miro on 2/18/24.
//

import UIKit

enum ViewCollapseState {
    case open
    case close
}

class ViewCollapseImageView: UIImageView {

    var isOpen: Bool = true {
        didSet {
            switch self.isOpen {
            case true:
                self.image = .chevronUp
            case false:
                self.image = .chevronDown
            }
        }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
