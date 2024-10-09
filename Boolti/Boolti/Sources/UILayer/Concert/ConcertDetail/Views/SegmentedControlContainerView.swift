//
//  BooltiSegmentedControlView.swift
//  Boolti
//
//  Created by Miro on 10/3/24.
//

import UIKit

final class SegmentedControlContainerView: UIView {

    var segmentedControl: UnderlineSegmentedControl

    private var boundaryLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()

    init(items: [Any]?) {
        self.segmentedControl = UnderlineSegmentedControl(items: items)
        super.init(frame: .zero)

        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubviews([
            self.boundaryLineView,
            self.segmentedControl
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.boundaryLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
    }
}
