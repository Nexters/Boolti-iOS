//
//  CastTeamListFooterView.swift
//  Boolti
//
//  Created by Miro on 10/6/24.
//
import UIKit

import SnapKit

final class CastTeamListFooterView: UICollectionReusableView {

    private let boundaryLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(boundaryLineView)

        self.boundaryLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

}
