//
//  BooltiEventPopupViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class BooltiEventPopupViewController: UIViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()

    // MARK: UI Components

    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )

        return imageView
    }()
    
    private let stopShowButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.title = "오늘 하루 그만 보기"
        config.attributedTitle?.font = .body3
        config.baseForegroundColor = .grey50
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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .body3
        button.setTitleColor(.grey95, for: .normal)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        
        return button
    }()
    
    private lazy var buttonStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews([self.stopShowButton,
                                       self.closeButton])
        
        return stackView
    }()
    
    private lazy var contentStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([self.eventImageView,
                                       self.buttonStackview])
        stackView.layer.cornerRadius = 8
        stackView.backgroundColor = .white00
        
        return stackView
    }()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindComponents()
    }
    
    // MARK: Initailizer
    
    init(with popupData: PopupEntity) {
        super.init(nibName: nil, bundle: nil)
        
        self.eventImageView.setImage(with: popupData.eventUrl)
        self.bindEventImageView(with: popupData.eventUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension BooltiEventPopupViewController {
    
    private func bindComponents() {
        self.closeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                if owner.stopShowButton.isSelected {
                    UserDefaults.eventPopupStopShowDate = Date()
                }
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.stopShowButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.stopShowButton.isSelected.toggle()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindEventImageView(with url: String) {
        self.eventImageView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                guard let url = URL(string: url) else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - UI

extension BooltiEventPopupViewController {
    
    private func configureUI() {
        self.view.addSubview(self.contentStackview)

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.eventImageView.snp.makeConstraints { make in
            let width = self.view.frame.width - 64
            make.width.equalTo(width)
            make.height.equalTo(width * 360 / 311)
        }
        
        self.buttonStackview.snp.makeConstraints { make in
            make.width.equalTo(self.eventImageView)
            make.height.equalTo(56)
        }

        self.closeButton.snp.makeConstraints { make in
            make.width.equalTo(68)
        }
        
        self.contentStackview.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
