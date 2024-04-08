//
//  TermsAgreementViewController.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import SafariServices

final class TermsAgreementViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: TermsAgreementViewModel
    private let disposeBag = DisposeBag()
    
    enum Text {
        static let subtitle = "원활한 이용을 위해 서비스 이용약관 확인 후 \n동의해 주세요"
        static let terms = "서비스 이용약관"
    }
    
    private let bottomSheetLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        return view
    }()
    
    private let agreementButton = BooltiButton(title: "약관 동의하고 시작하기")
    
    private let greetingLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline1
        label.textColor = .grey05
        label.text = "불티를 찾아주셔서 감사합니다"
        
        return label
    }()
    
    private let subtitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardR(16)
        label.numberOfLines = 2
        label.textColor = .grey30
        label.text = Text.subtitle
        label.setUnderLine(to: Text.terms)
        return label
    }()
    
    // MARK: Init
    
    init(viewModel: TermsAgreementViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
        self.setPrivacyPolicyLabelTapRecognizer()
    }
}

// MARK: - Methods

extension TermsAgreementViewController {
    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }
    
    private func bindInputs() {
        self.agreementButton.rx.tap
            .asDriver()
            .throttle(.seconds(2), latest: false)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.didAgreementButtonTapEvent.onNext(())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.didSignUpFinished
            .subscribe(with: self) { owner, _ in
                owner.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setPrivacyPolicyLabelTapRecognizer() {
        self.subtitleLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(privacyPolicyLabelTapped)
        )
        self.subtitleLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func privacyPolicyLabelTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.subtitleLabel)
        
        if let calaulatedTermsRect = self.subtitleLabel.boundingRectForCharacterRange(subText: Text.terms),
           calaulatedTermsRect.contains(point) {
            guard let url = URL(string: AppInfo.termsPolicyLink) else { return }
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .formSheet
            self.present(safariViewController, animated: true)
        }
    }
}

// MARK: - UI

extension TermsAgreementViewController {
    
    private func configureUI() {
        self.view.addSubview(self.bottomSheetLayerView)
        self.bottomSheetLayerView.addSubviews([self.greetingLabel, self.subtitleLabel, self.agreementButton])

        self.view.backgroundColor = .black100.withAlphaComponent(0.8)
        self.configureConstraints()
    }

    private func configureConstraints() {
        self.bottomSheetLayerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
        }

        self.greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.bottom.equalTo(self.subtitleLabel.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        self.subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.agreementButton.snp.top).offset(-26)
            make.horizontalEdges.equalTo(self.agreementButton)
        }

        self.agreementButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.greetingLabel)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
    }
}
