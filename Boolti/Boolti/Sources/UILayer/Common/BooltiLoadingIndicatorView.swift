//
//  BooltiLoadingIndicatorView.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit

final class BooltiLoadingIndicatorView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            isLoading ? self.hide() : self.show()
        }
    }

    private func hide() {
        self.isHidden = true
        self.startAnimating()
    }

    private func show() {
        self.isHidden = false
        self.stopAnimating()
    }
}
