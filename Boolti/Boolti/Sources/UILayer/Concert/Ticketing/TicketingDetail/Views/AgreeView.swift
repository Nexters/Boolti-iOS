//
//  AgreeView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/19/24.
//

import UIKit

import RxSwift
import RxCocoa

final class AgreeView: UIView {
    
    // MARK: Properties
    
    enum ButtonType {
        case allCheck
        case check
    }
    
    private let disposeBag = DisposeBag()
    let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
    
    // MARK: UI Component
    
    private lazy var allAgreeButton = self.makeAgreeRowButton(type: .allCheck, title: "주문내용 확인 및 결제 동의")
    
    private lazy var collectionButton = self.makeAgreeRowButton(type: .check, title: "[필수] 개인정보 수집・이용 동의")
    private lazy var collectionOpenButton = self.makeOpenButton()
    
    private lazy var offerButton = self.makeAgreeRowButton(type: .check, title: "[필수] 개인정보 제 3자 정보 제공 동의")
    private lazy var offerOpenButton = self.makeOpenButton()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

// MARK: - Methods

extension AgreeView {
    
    private func makeAgreeRowButton(type: ButtonType, title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.title = title
        config.attributedTitle?.font = type == .allCheck ? .body3 : .body1
        config.baseForegroundColor = type == .allCheck ? .grey10 : .grey50
        config.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: config)
        
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = type == .allCheck ? .checkboxOn : .miniCheckOn
            default:
                button.configuration?.image = type == .allCheck ? .checkboxOff : .miniCheckOff
            }
        }
        return button
    }
    
    private func makeOpenButton() -> UIButton {
        let button = UIButton()
        button.setTitle("보기", for: .normal)
        button.tintColor = .grey50
        button.titleLabel?.font = .pretendardR(14)
        button.setUnderline(font: .body1, textColor: .grey50)
        return button
    }
    
    private func bindInput() {
        self.allAgreeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.allAgreeButton.isSelected.toggle()
                owner.collectionButton.isSelected.toggle()
                owner.offerButton.isSelected.toggle()
                
                owner.isAllAgreeButtonSelected.accept(owner.allAgreeButton.isSelected)
            })
            .disposed(by: self.disposeBag)
    }
    
    func didCollectionOpenButtonTap() -> Signal<Void> {
        return self.collectionOpenButton.rx.tap.asSignal()
    }
    
    func didOfferOpenButtonTap() -> Signal<Void> {
        return self.offerOpenButton.rx.tap.asSignal()
    }
    
}

// MARK: - UI

extension AgreeView {
    
    private func configureUI() {
        self.addSubviews([self.allAgreeButton,
                          self.collectionButton,
                          self.collectionOpenButton,
                          self.offerButton,
                          self.offerOpenButton])
        
        self.backgroundColor = .grey90
    }
    
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(136)
        }
      
        self.allAgreeButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        
        self.collectionButton.snp.makeConstraints { make in
            make.leading.equalTo(self.allAgreeButton)
            make.top.equalTo(self.allAgreeButton.snp.bottom).offset(20)
        }
        
        self.collectionOpenButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(self.collectionButton)
        }
        
        self.offerButton.snp.makeConstraints { make in
            make.leading.equalTo(self.allAgreeButton)
            make.top.equalTo(self.collectionButton.snp.bottom).offset(4)
        }
        
        self.offerOpenButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(self.offerButton)
        }
    }
    
}
