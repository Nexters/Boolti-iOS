//
//  ResignInfoViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ResignInfoViewController: BooltiViewController {
    
    // MARK: Properties

    private let disposeBag = DisposeBag()
    
    private let resignReasonViewControllerFactory: () -> ResignReasonViewController
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "회원 탈퇴"))
    
    private let mainTitle: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point4
        label.textColor = .grey05
        label.text = "탈퇴 전, 꼭 읽어 보세요!"
        return label
    }()
    
    private let resignInfoLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey50
        label.numberOfLines = 0
        label.text = """
        • 주최한 공연 정보는 사라지지 않아요
        • 예매한 티켓은 전부 사라지며 복구할 수 없어요
        • 탈퇴일로부터 30일 이내 재 로그인 시 계정 삭제를 취소할 수 있어요
        """
        label.setHeadIndent()
        return label
    }()
    
    private let nextButton = BooltiButton(title: "다음")
    
    // MARK: Init
    
    init(resignReasonViewControllerFactory: @escaping () -> ResignReasonViewController) {
        self.resignReasonViewControllerFactory = resignReasonViewControllerFactory
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bindUIConponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension ResignInfoViewController {
    
    private func bindUIConponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let viewController = self.resignReasonViewControllerFactory()
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ResignInfoViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubviews([self.navigationBar,
                               self.mainTitle,
                               self.resignInfoLabel,
                               self.nextButton])
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.mainTitle.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.resignInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mainTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
}
