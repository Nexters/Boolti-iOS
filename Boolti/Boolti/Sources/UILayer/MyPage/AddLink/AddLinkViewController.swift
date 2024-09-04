//
//  AddLinkViewController.swift
//  Boolti
//
//  Created by Miro on 9/5/24.
//

import UIKit

final class AddLinkViewController: BooltiViewController {

    private let navigationBar = BooltiNavigationBar(type: .addLink)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([navigationBar])
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
