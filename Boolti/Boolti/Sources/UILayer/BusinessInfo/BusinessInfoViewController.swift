//
//  BusinessInfoViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class BusinessInfoViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "사업자 정보"))
    
    private lazy var companyNameLabel = self.makeLabel(with: "스튜디오 불티")
    private lazy var ceoLabel = self.makeLabel(with: "대표 : 김혜선")
    private lazy var businessNumberLabel = self.makeLabel(with: "사업자 등록번호 : 202-43-63442")
    private lazy var addressLabel = self.makeLabel(with: "주소 : 경기도 남양주시 화도읍 묵현로 25번길 12-5")
    private lazy var hostingLabel = self.makeLabel(with: "호스팅 서비스 : 스튜디오 불티")
    private lazy var mailOrderBusinessLabel = self.makeLabel(with: "통신판매업 신고번호 : 2024-화도수동-0518")
    private lazy var phoneNumberLabel = self.makeLabel(with: "문의전화 : 0507-1363-5690")
    private lazy var emailLabel = self.makeLabel(with: "이메일 : studio.boolti@gmail.com")
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubviews([self.companyNameLabel,
                                       self.ceoLabel,
                                       self.businessNumberLabel,
                                       self.addressLabel,
                                       self.hostingLabel,
                                       self.mailOrderBusinessLabel,
                                       self.phoneNumberLabel,
                                       self.emailLabel])
        stackView.setCustomSpacing(16, after: self.companyNameLabel)
        return stackView
    }()
    
    private lazy var termsPolicyButton = self.makeButton(with: "서비스 이용약관")
    private lazy var privacyPolicyButton = self.makeButton(with: "개인정보 처리방침")
    private lazy var refundPolicyButton = self.makeButton(with: "환불 정책")
    
    private lazy var policyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.addArrangedSubviews([self.termsPolicyButton,
                                       self.privacyPolicyButton,
                                       self.refundPolicyButton])
        return stackView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bindNavigationBar()
        self.bindPolicyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension BusinessInfoViewController {
    
    private func makeLabel(with text: String) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .body3
        label.text = text
        label.textColor = text == "스튜디오 불티" ? .grey10 : .grey30
        return label
    }
    
    private func makeButton(with text: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = text
        config.attributedTitle?.font = .body3
        config.baseForegroundColor = .grey30
        config.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.background.cornerRadius = 4
        config.background.backgroundColor = .grey85

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        
        let navigateImageView = UIImageView(image: .navigate.withRenderingMode(.alwaysTemplate))
        navigateImageView.tintColor = .grey50
        button.addSubview(navigateImageView)
        
        navigateImageView.snp.makeConstraints { make in
            make.right.equalTo(button).offset(-20)
            make.centerY.equalTo(button)
        }

        return button
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindPolicyButton() {
        self.termsPolicyButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.termsPolicyLink) else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: self.disposeBag)
        
        self.privacyPolicyButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.privacyPolicyLink) else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: self.disposeBag)
        
        self.refundPolicyButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.refundPolicyLink) else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension BusinessInfoViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.infoStackView,
                               self.policyStackView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.policyStackView.snp.makeConstraints { make in
            make.top.equalTo(self.infoStackView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
