//
//  QRExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

import RxSwift

final class QRExpandViewController: BooltiViewController {
    
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

    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey10
        view.layer.cornerRadius = 8

        return view
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .greyBooltiLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let ticketNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey85
        label.font = .subhead1

        return label
    }()

    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        return imageView
    }()

    // MARK: Init
    
    init(viewModel: QRExpandViewModel) {
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
        self.view.addSubviews([
            self.contentBackgroundView,
            self.closeButton,
        ])

        self.contentBackgroundView.addSubviews([
            self.ticketNameLabel,
            self.qrImageView,
            self.booltiLogoImageView
        ])

        self.view.backgroundColor = .white00

        self.ticketNameLabel.text = self.viewModel.output.ticketName
        self.qrImageView.image = self.viewModel.output.qrCodeImage
    }
    
    private func configureConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        self.contentBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(292)
            make.height.equalTo(360)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }

        self.qrImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(260)
        }

        self.ticketNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrImageView.snp.bottom).offset(12)
        }
    }
}
