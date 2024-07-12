//
//  GiftCompletionViewController.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

import RxSwift
import RxCocoa
import RxKakaoSDKShare

final class GiftCompletionViewController: BooltiViewController, CompletionViewControllerProtocol {

    // MARK: Properties

    let viewModel: GiftCompletionViewModel
    private let disposeBag = DisposeBag()

    // MARK: UI Component

    private let navigationBar = BooltiNavigationBar(type: .ticketingCompletion)

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroM(24)
        label.textColor = .grey05
        label.numberOfLines = 0
        label.text = "결제를 완료했어요\n카카오톡에서 받는 분을\n선택해 주세요"
        return label
    }()

    private let firstUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()

    private lazy var reservationTitleLabel = self.makeLabel(text: "주문 번호")
    private lazy var reservationInfoLabel = self.makeLabel()
    private lazy var reservationStackView = self.makeInfoRowStackView(title: reservationTitleLabel, info: reservationInfoLabel)

    private lazy var recipientTitleLabel = self.makeLabel(text: "받는 분")
    private lazy var recipientInfoLabel = self.makeLabel()
    private lazy var recipientStackView = self.makeInfoRowStackView(title: recipientTitleLabel, info: recipientInfoLabel)

    // 선물하기 티켓일 경우 -> 추후에 분기처리해야됨!
    private lazy var kakaoGiftButton = SocialServiceButton(title: "받는 분 선택하기", type: .kakao)
    private lazy var giftNoticeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey40
        label.text = AppInfo.giftPolicy
        label.setHeadIndent()
        label.numberOfLines = 0

        return label
    }()
    private lazy var giftInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.addArrangedSubviews([self.kakaoGiftButton, self.giftNoticeLabel])

        return stackView
    }()

    private lazy var firstInfoStackView = self.makeInfoGroupStackView(with: [
        reservationStackView,
        recipientStackView,
        giftInformationStackView,
    ])

    private let secondUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()

    private lazy var amountTitleLabel = self.makeLabel(text: "결제 금액")
    private lazy var amountInfoLabel = self.makeLabel()
    private lazy var amountStackView = self.makeInfoRowStackView(title: amountTitleLabel, info: amountInfoLabel)

    private lazy var ticketTitleLabel = self.makeLabel(text: "주문 티켓")
    private lazy var ticketInfoLabel = self.makeLabel()
    private lazy var ticketStackView = self.makeInfoRowStackView(title: ticketTitleLabel, info: ticketInfoLabel)

    private lazy var secondInfoStackView = self.makeInfoGroupStackView(with: [amountStackView, ticketStackView])

    private let reservedTicketView = ReservedTicketView()

    private let openReservationButton: BooltiButton = {
        let button = BooltiButton(title: "결제 내역보기")
        button.backgroundColor = .grey80
        return button
    }()

    // MARK: Init

    init(viewModel: GiftCompletionViewModel) {
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
        self.configureConstraints()
        self.bindComponents()
        self.bindInput()
        self.bindOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private func configureUI() {
        self.view.addSubviews([
            self.navigationBar,
            self.titleLabel,
            self.firstUnderlineView,
            self.firstInfoStackView,
            self.secondUnderlineView,
            self.secondInfoStackView,
            self.reservedTicketView,
            self.openReservationButton
        ])

        self.view.backgroundColor = .grey95
    }
}

extension GiftCompletionViewController {

    // MARK: Binding

    private func bindComponents() {
        self.kakaoGiftButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                // 아래 try catch로 에러 핸들링하는 걸로 변경
                guard let giftReservationDetail = try! owner.viewModel.output.giftReservationDetail.value() else { return }

                if ShareApi.isKakaoTalkSharingAvailable(){
                    let link = Link(webUrl: URL(string:"https://www.naver.com/"),
                                    mobileWebUrl: URL(string:"https://www.naver.com/"))

                    // web link로 이어질 예정 -> 웹과 이야기해봐야됨
                    let appLink = Link(iosExecutionParams: ["second": "vvv"])

                    // 해당 appLink를 들고 있을 버튼을 만들어준다.
                    let button = Button(title: "선물 확인하기", link: appLink)

                    let itemContent = ItemContent(profileText: "To. 받는 분 이름")
                    let content = Content(
                        title: "보내는 분님이 보낸 선물이 도착했어요.",
                        imageUrl: URL(string:giftReservationDetail.giftImageURLPath)!,
                        description: "0월 0일까지 불티앱에서 선물을 등록해주세요.",
                        link: appLink
                    )
                    let template = FeedTemplate(content: content, itemContent: itemContent, buttons: [button])

                    //메시지 템플릿 encode
                    if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                        if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                            ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                                if let error = error {
                                    print("error : \(error)")
                                }
                                else {
                                    print("defaultLink(templateObject:templateJsonObject) success.")
                                    guard let linkResult = linkResult else { return }
                                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                }
            }
            .disposed(by: self.disposeBag)

        self.openReservationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeTab(to: .myPage)
                UserDefaults.landingDestination = .reservationDetail(reservationID: owner.viewModel.giftID)
                NotificationCenter.default.post(
                    name: Notification.Name.LandingDestination.reservationDetail,
                    object: nil
                )
            }
            .disposed(by: self.disposeBag)
    }

    private func bindInput() {
        self.navigationBar.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                guard let viewControllers = self.navigationController?.viewControllers else { return }
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            .disposed(by: self.disposeBag)

        self.rx.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.giftReservationDetail
            .compactMap { $0 }
            .bind(with: self) { owner, entity in
                owner.reservationInfoLabel.text = entity.csReservationID
                owner.recipientInfoLabel.text = "\(entity.recipientName) / \(entity.recipientPhoneNumber.formatPhoneNumber())"
                owner.ticketInfoLabel.text = "\(entity.salesTicketName) / \(entity.ticketCount)매"
                owner.reservedTicketView.setData(
                    concertName: entity.concertTitle,
                    concertDate: entity.showDate,
                    posterURL: entity.concertPosterImageURLPath
                )

                switch entity.ticketType {
                case .invitation:
                    owner.configureInvitationTicketCase(with: entity)
                case .sale:
                    owner.configureSaleTicketCases(with: entity)
                }
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: UI Method

    private func configureConstraints() {

        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.firstUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }

        self.kakaoGiftButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.firstInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.firstUnderlineView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.secondUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(self.firstInfoStackView.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }

        self.secondInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.secondUnderlineView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.reservedTicketView.snp.makeConstraints { make in
            make.top.equalTo(self.secondInfoStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.openReservationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    func configureInvitationTicketCase(with entity: GiftReservationDetailEntity) {
        self.amountInfoLabel.text = "0원 (초청 코드)"
    }

    func setFreeTicketCase(with entity: GiftReservationDetailEntity) {
        self.amountInfoLabel.text = "0원"
    }

    func setCardPaymentTicketCase(with entity: GiftReservationDetailEntity) {
        guard let paymentCardDetail = entity.paymentCardDetail else { return }
        let installmentPlanMonths = paymentCardDetail.installmentPlanMonths
        let paymentMonth = installmentPlanMonths == "0" ? "일시불" : "\(installmentPlanMonths)"

        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원\n(\(paymentCardDetail.issuer) / \(paymentMonth))"
    }

    func setAccountTransferPaymentTicketCase(with entity: GiftReservationDetailEntity) {
        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원 (계좌이체)"
    }

    func setSimplePaymentTicketCase(with entity: GiftReservationDetailEntity) {
        guard let easyPayProvider = entity.easyPayProvider else { return }
        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원\n(\(easyPayProvider) / 간편결제)"
    }
    

    // MARK: Private Method
    private func changeTab(to tab: HomeTab) {
        NotificationCenter.default.post(
            name: Notification.Name.didTabBarSelectedIndexChanged,
            object: nil,
            userInfo: ["tabBarIndex" : tab.rawValue]
        )
    }
}
