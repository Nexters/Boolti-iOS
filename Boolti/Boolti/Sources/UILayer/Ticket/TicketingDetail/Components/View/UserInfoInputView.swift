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
    case TicketHolder
    case Depositor
}

final class UserInfoInputView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let title: UILabel = {
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
    
    private let nameTextField = BooltiTextField()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30
        label.text = "연락처"
        return label
    }()
    
    private let phoneNumberTextField = BooltiTextField()
    
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
        case .TicketHolder:
            self.configureTicketHolderUI()
        case .Depositor:
            self.configureDepositorUI()
        }
        
        self.bindEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension UserInfoInputView {
    
    private func bindEvents() {
        self.isEqualButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.isEqualButton.isSelected.toggle()
                
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
    }
    
    private func resetTextField() {
        self.nameTextField.text = nil
        self.phoneNumberTextField.text = nil
    }
}

// MARK: - UI

extension UserInfoInputView {
    
    private func configureTicketHolderUI() {
        self.configureDefaultUI()
        
        self.title.text = "예매자 정보"
    }
    
    private func configureDepositorUI() {
        self.configureDefaultUI()
        
        self.addSubview(isEqualButton)
        self.configureDepositorConstraints()
        
        self.title.text = "입금자 정보"
    }
    
    private func configureDefaultUI() {
        self.addSubviews([title, nameLabel, nameTextField, phoneNumberLabel, phoneNumberTextField])
        self.configureDefaultConstraints()
        
        self.backgroundColor = .grey90
        
        self.nameTextField.setPlaceHolderText(placeholder: "예) 김불티")
        self.phoneNumberTextField.setPlaceHolderText(placeholder: "예) 010-1234-5678")
    }
    
    private func configureDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        
        self.title.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.title)
            make.centerY.equalTo(self.nameTextField)
            make.width.equalTo(44)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(20)
            make.left.equalTo(self.nameLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(20)
        }
        
        self.phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(self.title)
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
            make.centerY.equalTo(self.title)
            make.right.equalToSuperview().inset(20)
        }
    }
}
