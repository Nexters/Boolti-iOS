//
//  ConcertViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit
import SnapKit

final class ConcertViewController: UIViewController {

    private let navigationView: BooltiNavigationView = {
        let view = BooltiNavigationView(type: .payment)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .yellow
        
        self.view.addSubviews([navigationView])
        self.navigationView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
}
