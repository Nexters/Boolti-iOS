//
//  QRExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

import RxSwift

final class QRExpandViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: QRExpandViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey90
        return button
    }()
    
    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .qrTopLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let qrImageView = UIImageView()
    
    // MARK: Init
    
    init(viewModel: QRExpandViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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

extension QRExpandViewController {
    
    private func bindUIComponents() {
        self.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension QRExpandViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.closeButton,
                               self.booltiLogoImageView,
                               self.qrImageView])
        
        self.view.backgroundColor = .white00
        self.qrImageView.image = self.viewModel.qrCodeImage
    }
    
    private func configureConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        
        self.qrImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(260)
        }
        
        self.booltiLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.qrImageView.snp.top).offset(-20)
        }
    }
}
