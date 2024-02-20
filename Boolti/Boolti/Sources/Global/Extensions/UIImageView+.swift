//
//  UIImageView+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/8/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String) {
        self.kf.setImage(with: URL(string: urlString))
    }
}
