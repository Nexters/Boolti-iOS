//
//  GiftReservationRefundAskViewController.swift
//  Boolti
//
//  Created by Miro on 7/23/24.
//

import UIKit

import RxSwift

final class GiftReservationRefundAskViewController: BooltiViewController {

    private let giftID: String

    private let disposeBag = DisposeBag()

    private let contentBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8

        return view
    }()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.numberOfLines = 0
        label.text = "선물을 취소하면 받은 분의 초대장\n 화면에 취소 메세지가 노출되며 기존에\n 결제한 수단으로 환불이 진행됩니다.\n선물을 취소하시겠습니까?"
        label.textAlignment = .center

        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()


    private let requestRefundButton: BooltiButton = {
        let button = BooltiButton(title: "취소 요청하기")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(giftID: String) {
        self.giftID = giftID
        super.init()
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.configureSubViews()
        self.bindUIComponents()

    }

    private func configureSubViews() {

        self.view.addSubviews([
            self.contentBackGroundView,
            self.titleLabel,
            self.closeButton,
            self.requestRefundButton
        ])

        self.contentBackGroundView.snp.makeConstraints { make in
            make.width.equalTo(311)
            make.height.equalTo(248)
            make.center.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
            make.top.equalTo(self.closeButton.snp.bottom).offset(20)
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentBackGroundView.snp.top).inset(12)
            make.right.equalTo(self.contentBackGroundView.snp.right).inset(20)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(self.contentBackGroundView).inset(20)
        }
    }

    private func bindUIComponents() {
        self.closeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.requestRefundButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                // TODO: 아래 로직 MVP 배포 후 변경!..
                let DIContainer = GiftRefundRequestDIContainer(ticketReservationRepository: TicketReservationRepository(networkService: NetworkProvider()))
                let viewController = DIContainer.createGiftRefundRequestViewController(giftID: owner.giftID)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

}
