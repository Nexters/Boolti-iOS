//
//  BooltiNoticePopupViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class BooltiNoticePopupViewController: UIViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()

    // MARK: UI Components
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withTintColor(.grey50, renderingMode: .alwaysOriginal), for: .normal)

        return button
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.numberOfLines = 0
        
        return label
    }()
    
    private let emphasisDescriptionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey80
        view.layer.cornerRadius = 4
        view.isHidden = true
        
        return view
    }()
    
    private let emphasisDescriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body2
        label.textColor = .error
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey50
        label.numberOfLines = 0
        
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let confirmButton: BooltiButton = {
        let button = BooltiButton(title: "확인")
        
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureStackView()
        self.configureUI()
        self.bindComponents()
    }
    
    // MARK: Initailizer
    
    init(with popupData: PopupEntity) {
        super.init(nibName: nil, bundle: nil)
        
        self.setData(with: popupData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension BooltiNoticePopupViewController {
    
    private func bindComponents() {
        self.closeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setData(with popupData: PopupEntity) {
        self.titleLabel.text = popupData.noticeTitle
        self.titleLabel.setAlignment(.center)
        
        if let emphasisDescription = popupData.emphasisDescription {
            self.emphasisDescriptionBackgroundView.isHidden = false
            self.emphasisDescriptionLabel.text = emphasisDescription
            self.emphasisDescriptionLabel.setAlignment(.center)
        } else {
            self.emphasisDescriptionBackgroundView.isHidden = true
        }
        
        self.descriptionLabel.text = popupData.description
        self.descriptionLabel.setAlignment(.center)
    }

}

// MARK: - UI

extension BooltiNoticePopupViewController {
    
    private func configureStackView() {
        self.emphasisDescriptionBackgroundView.addSubview(self.emphasisDescriptionLabel)
        self.labelStackView.addArrangedSubviews([self.titleLabel,
                                                 self.emphasisDescriptionBackgroundView,
                                                 self.descriptionLabel])

        self.titleLabel.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 104)
        }
        
        self.emphasisDescriptionBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(self.titleLabel)
        }
        
        self.emphasisDescriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(self.titleLabel)
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .clear

        self.contentView.addSubviews([self.closeButton,
                                      self.labelStackView,
                                      self.confirmButton])
        self.view.addSubview(self.contentView)

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
        }

        self.closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.top.equalTo(self.closeButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        self.confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.labelStackView.snp.bottom).offset(28)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
    }
    
}
