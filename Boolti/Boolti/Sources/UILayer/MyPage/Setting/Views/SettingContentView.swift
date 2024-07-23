//
//  SettingContentView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/23/24.
//

import UIKit

final class SettingContentView: UIView {
    
    // MARK: UI Components

    let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()
    
    // MARK: Initailizer

    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UI

extension SettingContentView {
 
    private func configureUI() {
        self.backgroundColor = .grey90

        self.addSubview(self.titleLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}
