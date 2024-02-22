//
//  UpdatePopupViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import UIKit

import RxSwift
import SnapKit

final class UpdatePopupViewController: UIViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.text = "업데이트 알림"
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey50
        label.font = .body1
        label.numberOfLines = 2
        label.text = "지금 업데이트하고\n더 편리해진 불티를 만나보세요"
        label.setAlignCenter()
        
        return label
    }()
    
    private let updateButton = BooltiButton(title: "업데이트 하러가기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bind()
    }
}

// MARK: - Methods

extension UpdatePopupViewController {
    
    private func bind() {
        self.updateButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.openAppStore()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func openAppStore() {
        guard let url = URL(string: AppInfo.booltiAppStoreLink) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - UI

extension UpdatePopupViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.popupBackgroundView,
                               self.titleLabel,
                               self.subTitleLabel,
                               self.updateButton])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.popupBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.centerX.equalTo(self.popupBackgroundView)
            make.top.equalTo(self.popupBackgroundView).offset(32)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.popupBackgroundView)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        self.updateButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.popupBackgroundView)
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.popupBackgroundView).inset(20)
            make.bottom.equalTo(self.popupBackgroundView).offset(-20)
        }
    }
}
