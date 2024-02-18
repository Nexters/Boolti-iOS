//
//  EntranceCodeViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

import RxSwift

final class EntranceCodeViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: EntranceCodeViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let popUpBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.text = "입장코드"
        label.font = .subhead2
        label.textColor = .grey15
        return label
    }()
    
    private let codeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey80
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let codeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey15
        return label
    }()
    
    private let confirmButton = BooltiButton(title: "확인")
    
    // MARK: Init
    
    init(viewModel: EntranceCodeViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
    }
}

// MARK: - Methods

extension EntranceCodeViewController {
    
    private func bindUIComponents() {
        self.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension EntranceCodeViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.popUpBackgroundView,
                               self.titleLabel,
                               self.codeBackgroundView,
                               self.codeLabel,
                               self.confirmButton])
        
        self.view.backgroundColor = .black100.withAlphaComponent(0.85)
        self.codeLabel.text = self.viewModel.entranceCode
    }
    
    private func configureConstraints() {
        self.popUpBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(222)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.popUpBackgroundView).offset(32)
        }
        
        self.codeBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(self.popUpBackgroundView).inset(20)
        }
        
        self.codeLabel.snp.makeConstraints { make in
            make.center.equalTo(self.codeBackgroundView)
        }
        
        self.confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.codeBackgroundView.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(self.popUpBackgroundView).inset(20)
        }
    }
}
