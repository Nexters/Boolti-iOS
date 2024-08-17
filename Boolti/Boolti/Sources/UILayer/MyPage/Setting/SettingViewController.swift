//
//  SettingViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    private let logoutViewControllerFactory: () -> LogoutViewController
    private let resignInfoViewControllerFactory: () -> ResignInfoViewController
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "계정 설정"))
    
    private let userCodeContentView = SettingContentView(title: "식별 코드")
    private let userCodeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        return label
    }()
    
    private let oauthProviderContentView = SettingContentView(title: "연결 서비스")
    private let oauthProviderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let logoutLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "로그아웃"
        return label
    }()
    
    private let navigateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .navigate
        return imageView
    }()
    
    private lazy var logoutStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews([self.logoutLabel,
                                       self.navigateImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .grey90
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let resignNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey60)
        return button
    }()
    
    // MARK: Initailizer
    
    init(logoutViewControllerFactory: @escaping () -> LogoutViewController,
         resignInfoViewControllerFactory: @escaping () -> ResignInfoViewController) {
        self.logoutViewControllerFactory = logoutViewControllerFactory
        self.resignInfoViewControllerFactory = resignInfoViewControllerFactory
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureToastView(isButtonExisted: false)
        self.bindUIComponents()
        self.setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
}

// MARK: - Methods

extension SettingViewController {
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.userCodeLabel.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                UIPasteboard.general.string = "#\(UserDefaults.userCode)"
                owner.showToast(message: "식별 코드가 복사되었어요")
            }
            .disposed(by: self.disposeBag)
        
        self.resignNavigationButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(owner.resignInfoViewControllerFactory(), animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setData() {
        self.userCodeLabel.text = "#\(UserDefaults.userCode)"
        
        switch UserDefaults.oauthProvider {
        case .apple:
            self.oauthProviderImageView.image = .appleProvider
        case .kakao:
            self.oauthProviderImageView.image = .kakaoProvider
        }
    }
    
}

// MARK: - UI

extension SettingViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.userCodeContentView,
                               self.oauthProviderContentView,
                               self.logoutStackView,
                               self.resignNavigationButton])
        
        self.userCodeContentView.addSubview(self.userCodeLabel)
        self.oauthProviderContentView.addSubview(self.oauthProviderImageView)
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.userCodeContentView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
    
        self.userCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userCodeContentView.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.userCodeContentView.titleLabel)
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.oauthProviderContentView.snp.makeConstraints { make in
            make.top.equalTo(self.userCodeContentView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.oauthProviderImageView.snp.makeConstraints { make in
            make.top.equalTo(self.oauthProviderContentView.titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.oauthProviderContentView.titleLabel)
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.logoutStackView.snp.makeConstraints { make in
            make.top.equalTo(self.oauthProviderContentView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.resignNavigationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(38)
        }
    }
    
}
