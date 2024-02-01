//
//  UserInfoInputView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit
import RxSwift
import RxCocoa

enum userInfoInputType {
    case ticketHolder
    case depositor
}

final class UserInfoInputView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let isEqualButtonSelected = BehaviorRelay<Bool>(value: false)
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30
        label.text = "이름"
        return label
    }()
    
    private let nameTextField: BooltiTextField = {
        let button = BooltiTextField()
        button.setPlaceHolderText(placeholder: "예) 김불티")
        return button
    }()

    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30
        label.text = "연락처"
        return label
    }()

    private let phoneNumberTextField: BooltiTextField = {
        let button = BooltiTextField()
        button.setPlaceHolderText(placeholder: "예) 010-1234-5678")
        return button
    }()

    
    private let isEqualButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.title = "예매자와 입금자가 같아요"
        config.attributedTitle?.font = .body2
        config.baseForegroundColor = .orange01
        config.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: config)
        
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = .checkboxOn
            default:
                button.configuration?.image = .checkboxOff
            }
        }
        return button
    }()
    
    // MARK: Init
    
    init(type: userInfoInputType) {
        super.init(frame: .zero)
        
        switch type {
        case .ticketHolder:
            self.configureTicketHolderUI()
        case .depositor:
            self.configureDepositorUI()
        }
        
        self.bindInputs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension UserInfoInputView {
    
    private func bindInputs() {
        self.isEqualButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.isEqualButton.isSelected.toggle()
                owner.isEqualButtonSelected.accept(owner.isEqualButton.isSelected)
                
                owner.snp.updateConstraints { make in
                    if owner.isEqualButton.isSelected {
                        make.height.equalTo(66)
                    } else {
                        make.height.equalTo(210)
                    }
                }
                
                [owner.nameLabel, owner.nameTextField, owner.phoneNumberLabel, owner.phoneNumberTextField]
                    .forEach { $0.isHidden.toggle() }
                
                if !owner.isEqualButton.isSelected {
                    owner.resetTextField()
                }
            })
            .disposed(by: self.disposeBag)
        
        self.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                debugPrint(changedText)
            })
            .disposed(by: self.disposeBag)
        
        self.phoneNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                debugPrint(changedText)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func resetTextField() {
        self.nameTextField.text = nil
        self.phoneNumberTextField.text = nil
    }
    
    func isBothTextFieldsFilled() -> Observable<Bool> {
        let nameTextObservable = nameTextField.rx.text.orEmpty
        let phoneNumberTextObservable = phoneNumberTextField.rx.text.orEmpty

        return Observable.combineLatest(nameTextObservable, phoneNumberTextObservable, self.isEqualButtonSelected)
            .map { nameText, phoneNumberText, isEqualButtonSelected in
                return (!nameText.isEmpty && !phoneNumberText.isEmpty) || (!self.isEqualButton.isHidden && isEqualButtonSelected)
            }
    }
}

// MARK: - UI

extension UserInfoInputView {
    
    private func configureTicketHolderUI() {
        self.configureDefaultUI()
        
        self.titleLabel.text = "예매자 정보"
    }
    
    private func configureDepositorUI() {
        self.configureDefaultUI()
        
        self.addSubview(isEqualButton)
        self.configureDepositorConstraints()
        
        self.titleLabel.text = "입금자 정보"
    }
    
    private func configureDefaultUI() {
        self.addSubviews([self.titleLabel,
                          self.nameLabel,
                          self.nameTextField,
                          self.phoneNumberLabel,
                          self.phoneNumberTextField])
        self.configureDefaultConstraints()
        
        self.backgroundColor = .grey90
    }
    
    private func configureDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel)
            make.centerY.equalTo(self.nameTextField)
            make.width.equalTo(44)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.equalTo(self.nameLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(20)
        }
        
        self.phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel)
            make.centerY.equalTo(self.phoneNumberTextField)
            make.width.equalTo(self.nameLabel)
        }
        
        self.phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.nameTextField)
        }
    }
    
    private func configureDepositorConstraints() {
        self.isEqualButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview().inset(20)
        }
    }
}
