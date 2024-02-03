//
//  TicketListFooterView.swift
//  Boolti
//
//  Created by Miro on 2/3/24.
//

import UIKit

class TicketListFooterView: UICollectionReusableView {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey80
        view.layer.cornerRadius = 13

        return view
    }()

    let pageIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey05
        label.font = .body1

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([
            self.backgroundView,
            self.pageIndicatorLabel
        ])

        self.backgroundView.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.width.equalTo(60)
            make.center.equalToSuperview()
        }

        self.pageIndicatorLabel.snp.makeConstraints { make in
            make.center.equalTo(self.backgroundView.snp.center)
        }
    }
}
