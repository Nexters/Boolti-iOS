//
//  TicketCollectionViewCell.swift
//  Boolti
//
//  Created by Miro on 2/2/24.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        self.contentView.backgroundColor = .red
    }
}
