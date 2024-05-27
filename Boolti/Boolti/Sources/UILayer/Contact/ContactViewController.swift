//
//  ContactViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/25/24.
//

import UIKit

import RxSwift

final class ContactViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: ContactViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let buttonBackgroundView = UIView()
    private let buttontitle: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey10
        return label
    }()
    
    // MARK: Initailizer
    
    init(viewModel: ContactViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.setContactButtonTitle()
        self.bindInputs()
    }
    
}

// MARK: - Methods

extension ContactViewController {
    
    private func setContactButtonTitle() {
        self.buttontitle.text = self.viewModel.contactType == .call ? "전화 문의하기" : "문자 문의하기"
    }
    
    private func bindInputs() {
        self.buttonBackgroundView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                let urlScheme = owner.viewModel.contactType == .call ? "tel" : "sms"
                if let url = NSURL(string: "\(urlScheme)://\(owner.viewModel.phoneNumber)"),
                   UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension ContactViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.view.addSubviews([self.buttonBackgroundView,
                               self.buttontitle])
        
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }
    
    private func configureConstraints() {
        self.sheetPresentationController?.detents = [.custom { _ in return 120}]
        
        self.buttonBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        self.buttontitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.buttonBackgroundView)
            make.horizontalEdges.equalTo(self.buttonBackgroundView).inset(24)
        }
    }
    
}
