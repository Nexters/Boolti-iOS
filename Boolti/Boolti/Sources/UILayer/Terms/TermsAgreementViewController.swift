//
//  TermsAgreementViewController.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit

class TermsAgreementViewController: UIViewController {

    private let viewModel: TermsAgreementViewModel

    private let bottomSheetLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()

    private let agreementButton = BooltiBaseButton(title: "약관 동의하고 시작하기")
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "어서오세요 일이삼사오육치팔구십님!"
        label.font = .headline1

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "원활한 이용을 위해 서비스 이용약관 확인 후 \n동의해 주세요."
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    init(viewModel: TermsAgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.bottomSheetLayerView)
        self.bottomSheetLayerView.addSubviews([self.greetingLabel, self.subtitleLabel, self.agreementButton])
        self.configureConstraints()
    }

    private func configureConstraints() {
        self.bottomSheetLayerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(self.bottomSheetLayerView.snp.width).multipliedBy(0.6)
        }

        self.greetingLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        self.greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(self.greetingLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.greetingLabel)
        }

        self.agreementButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.greetingLabel)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
    }
}
