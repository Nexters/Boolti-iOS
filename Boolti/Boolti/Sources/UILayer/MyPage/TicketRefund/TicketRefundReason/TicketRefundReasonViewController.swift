//
//  TicketRefundReasonViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketRefundReasonViewController: BooltiViewController {

    typealias ReservationID = String
    typealias ReasonText = String

    private let ticketRefundRequestViewControllerFactory: (ReservationID, ReasonText) -> TicketRefundRequestViewController

    private let viewModel: TicketRefundReasonViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "환불 요청하기"))

    private let mainTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point4
        label.textColor = .grey05
        label.text = "환불 이유를 입력해 주세요"
        return label
    }()

    private let reasonTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = .init(top: 13, left: 12, bottom: 13, right: 12)
        textView.backgroundColor = .grey85
        textView.layer.cornerRadius = 4
        textView.font = .body3
        textView.text = "예) 티켓 종류 재 선택 후 다시 예매 할게요"
        textView.textColor = .grey70
        return textView
    }()

    private let nextButton = BooltiButton(title: "다음")

    init(ticketRefundRequestViewControllerFactory: @escaping (ReservationID, ReasonText) -> TicketRefundRequestViewController, viewModel: TicketRefundReasonViewModel) {
        self.ticketRefundRequestViewControllerFactory = ticketRefundRequestViewControllerFactory
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
    }

    private func configureUI() {
        self.view.addSubviews([
            self.navigationBar,
            self.mainTitleLabel,
            self.reasonTextView,
            self.nextButton
        ])
        self.view.backgroundColor = .grey95
        self.nextButton.isEnabled = false
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.mainTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.mainTitleLabel)
            make.height.equalTo(160)
        }

        self.nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }


    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let viewController = owner.ticketRefundRequestViewControllerFactory(owner.viewModel.reservationID, owner.reasonTextView.text)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)

        self.reasonTextView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.reasonTextView.textColor == .grey70 {
                    owner.reasonTextView.text = nil
                    owner.reasonTextView.textColor = .grey10
                }
            }
            .disposed(by: self.disposeBag)

        self.reasonTextView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                guard let reasonText = owner.reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

                if reasonText.isEmpty {
                    owner.reasonTextView.textColor = .grey70
                    owner.reasonTextView.text = "예) 티켓 종류 재 선택 후 다시 예매 할게요"
                    owner.nextButton.isEnabled = false
                } else {
                    owner.nextButton.isEnabled = true
                }
            }
            .disposed(by: self.disposeBag)
    }
}
