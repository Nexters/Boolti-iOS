//
//  TicketDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//
import UIKit

import RxSwift
import RxCocoa
import RxAppState
import RxGesture

final class TicketDetailViewController: BooltiViewController {

    // MARK: Properties

    typealias TicketID = String
    typealias ConcertID = String
    typealias ConcertId = Int
    typealias PhoneNumber = String
    typealias Tickets = [TicketDetailInformation]

    private let disposeBag = DisposeBag()
    private let viewModel: TicketDetailViewModel
    weak var delegate: TicketDetailViewControllerDelegate?
    private let ticketEntryCodeControllerFactory: (TicketID, ConcertID) -> TicketEntryCodeViewController
    private let qrExpandViewControllerFactory: (IndexPath, Tickets) -> QRExpandViewController
    private let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController
    private let contactViewControllerFactory: (ContactType, PhoneNumber) -> ContactViewController

    // MARK: UI Component

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "티켓 상세"))

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .grey95
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .grey30

        return refreshControl
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()

    private let concertDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 55, left: 20, bottom: 24, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()

    private let concertDetailBackgroundView = GradientBackgroundView()

    private let footerButton =  UIButton()

    private lazy var QRCodeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0 // 기본적으로 10으로 설정되어있다. 따라서 0으로 설정해줘야된다.

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(
            TicketCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketCollectionViewCell.className
        )
        collectionView.backgroundColor = .white00
        collectionView.layer.cornerRadius = 8
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private let QRCodePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .darkGray

        return pageControl
    }()

    private let ticketNoticeView = TicketNoticeView()
    private let organizerInfoView = OrganizerInfoView(horizontalInset: .zero, verticalInset:.zero , height: 98)
    private let reversalPolicyView = ReversalPolicyView()
    private let cancelReceivedGiftPopView = BooltiPopupView()

    private lazy var copyAddressButton = self.makeButton(
        title: "공연장 주소 복사",
        color: .grey70,
        titleColor: .grey05
    )
    private lazy var showConcertDetailButton = self.makeButton(
        title: "공연 정보 보기",
        color: .grey20,
        titleColor: .grey90
    )
    private lazy var horizontalButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubviews([
            self.copyAddressButton,
            self.showConcertDetailButton
        ])
        stackView.spacing = 9
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: .zero, bottom: 16, right: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillEqually

        return stackView
    }()

    // MARK: Init

    init(
        viewModel: TicketDetailViewModel,
        ticketEntryCodeViewControllerFactory: @escaping (TicketID, ConcertID) -> TicketEntryCodeViewController,
        qrExpandViewControllerFactory: @escaping (IndexPath, Tickets) -> QRExpandViewController,
        concertDetailViewControllerFactory: @escaping (Int) -> ConcertDetailViewController,
        contactViewControllerFactory: @escaping (ContactType, PhoneNumber) -> ContactViewController
    ) {
        self.viewModel = viewModel
        self.ticketEntryCodeControllerFactory = ticketEntryCodeViewControllerFactory
        self.qrExpandViewControllerFactory = qrExpandViewControllerFactory
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory
        self.contactViewControllerFactory = contactViewControllerFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.configureUI()
        self.configureToastView(isButtonExisted: false)
        self.configureLoadingIndicatorView()
        self.bindUIComponents()
    }

    override func viewDidLayoutSubviews() {
        self.setCustomStackViewSpacing()
    }

    // MARK: - Binding Methods

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindUIComponents() {
        self.bindCollectionView()
        self.bindConcertDetailButton()
        self.bindInquiryView()

        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.reversalPolicyView.didViewCollapseButtonTap
            .bind(with: self) { owner, _ in
                owner.scrollToBottom()
            }
            .disposed(by: self.disposeBag)

        self.footerButton.rx.tap
            .bind(with: self) { owner, _ in

                guard let ticketDetail = owner.viewModel.output.fetchedTicketDetail.value else { return }

                if ticketDetail.showStatus == .onShowDate {
                    let concertID = "\(ticketDetail.concertID)"
                    let currentTicketIndex = owner.QRCodePageControl.currentPage
                    let currentTicket = ticketDetail.ticketInformations[currentTicketIndex]
                    let currentTicketID = "\(currentTicket.ticketID)"

                    let viewController = owner.ticketEntryCodeControllerFactory(currentTicketID, concertID)
                    viewController.modalPresentationStyle = .overCurrentContext
                    owner.definesPresentationContext = true
                    owner.present(viewController, animated: true)
                } else if ticketDetail.isGift {
                    owner.cancelReceivedGiftPopView.showPopup(with: .cancelReceivedGift)
                }
            }
            .disposed(by: self.disposeBag)

        self.cancelReceivedGiftPopView.didConfirmButtonTap()
            .do(onNext: { [weak self] _ in
                self?.cancelReceivedGiftPopView.isHidden = true
            })
            .emit(to: self.viewModel.input.didCancelGiftButtonTappedEvent)
            .disposed(by: self.disposeBag)

        self.cancelReceivedGiftPopView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.cancelReceivedGiftPopView.isHidden = true
            }
            .disposed(by: self.disposeBag)
    }

    private func bindCollectionView() {
        self.QRCodeCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)

        self.QRCodeCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                guard let entity = owner.viewModel.output.fetchedTicketDetail.value else { return }
                let tickets = entity.ticketInformations
                let viewController = owner.qrExpandViewControllerFactory(indexPath, tickets)
                viewController.modalPresentationStyle = .fullScreen
                owner.present(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.QRCodeCollectionView.rx.didScroll
            .subscribe(with: self) { owner, _ in
                let cellIndex = owner.calculateCollectionViewItemIndex()
                owner.QRCodePageControl.rx.currentPage.onNext(cellIndex)
            }
            .disposed(by: self.disposeBag)

        self.QRCodeCollectionView.rx.didEndDecelerating
            .subscribe(with: self) { owner, _ in
                owner.setfooterButton()
            }
            .disposed(by: self.disposeBag)
    }

    private func bindConcertDetailButton() {
        self.copyAddressButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let streetAddress = owner.viewModel.output.fetchedTicketDetail.value?.streetAddress else { return }
                UIPasteboard.general.string = streetAddress
                owner.showToast(message: "공연장 주소가 복사되었어요")
            }
            .disposed(by: self.disposeBag)

        self.showConcertDetailButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let concertId = owner.viewModel.output.fetchedTicketDetail.value?.concertID else { return }
                let viewController = owner.concertDetailViewControllerFactory(concertId)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindInquiryView() {
        self.organizerInfoView.didCallButtonTap()
            .emit(with: self) { owner, _ in
                guard let phoneNumber = owner.viewModel.output.fetchedTicketDetail.value?.hostPhoneNumber else { return }
                owner.present(owner.contactViewControllerFactory(.call, phoneNumber), animated: true)
            }
            .disposed(by: self.disposeBag)

        self.organizerInfoView.didMessageButtonTap()
            .emit(with: self) { owner, _ in
                guard let phoneNumber = owner.viewModel.output.fetchedTicketDetail.value?.hostPhoneNumber else { return }
                owner.present(owner.contactViewControllerFactory(.message, phoneNumber), animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindInput() {
        self.rx.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.tabBarController?.tabBar.isHidden = true
                owner.viewModel.input.viewWillAppearEvent.onNext(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {

        self.viewModel.output.isLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(self.isLoading)
            .disposed(by: self.disposeBag)

        self.viewModel.output.fetchedTicketDetail
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(with: self) { owner, ticketDetailItem in
                guard let ticketDetailItem else { return }
                owner.setData(with: ticketDetailItem)
            }
            .disposed(by: self.disposeBag)

        let tickets = self.viewModel.output.fetchedTicketDetail
            .compactMap { $0?.ticketInformations }

        tickets
            .bind(to: self.QRCodeCollectionView.rx.items(
                cellIdentifier: TicketCollectionViewCell.className,
                cellType: TicketCollectionViewCell.self)
            ) { [weak self] index, entity, cell in
                cell.setData(with: entity)
                self?.setfooterButton()
            }
            .disposed(by: self.disposeBag)

        tickets
            .map { $0.count }
            .distinctUntilChanged()
            .bind(to: self.QRCodePageControl.rx.numberOfPages)
            .disposed(by: self.disposeBag)


        self.viewModel.output.didCanceledGift
            .bind(with: self) { owner, _ in
                owner.delegate?.ticketDetailViewControllerDidCancelGift(owner)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: Methods

    private func configureUI() {

        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar, self.scrollView, self.cancelReceivedGiftPopView])

        self.scrollView.addSubviews([
            self.refreshControl,
            self.contentStackView,
        ])

        self.concertDetailStackView.addArrangedSubviews([
            self.QRCodeCollectionView,
            self.QRCodePageControl,
            self.ticketNoticeView,
            self.organizerInfoView,
            self.horizontalButtonStackView
        ])

        self.contentStackView.addArrangedSubviews([
            self.concertDetailStackView,
            self.reversalPolicyView,
            self.footerButton
        ])

        self.concertDetailStackView.insertSubview(self.concertDetailBackgroundView, at: 0)
        self.configureConstraints()
    }

    private func configureConstraints() {

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(29)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.snp.horizontalEdges).inset(29)
        }

        self.concertDetailStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        self.concertDetailBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.QRCodeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(358)
        }

        self.QRCodePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        self.horizontalButtonStackView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }

        self.footerButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        self.contentStackView.setCustomSpacing(20, after: self.concertDetailStackView)

        self.cancelReceivedGiftPopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setCustomStackViewSpacing() {
        if QRCodePageControl.numberOfPages == 1 {
            self.concertDetailStackView.setCustomSpacing(50, after: self.QRCodeCollectionView)
            self.concertDetailBackgroundView.updateUIComponentsForSingleTicket()
        } else {
            self.concertDetailStackView.setCustomSpacing(10, after: self.QRCodeCollectionView)
            self.concertDetailStackView.setCustomSpacing(30, after: self.QRCodePageControl)
        }
    }

    private func setData(with entity: TicketDetailItemEntity) {
        self.ticketNoticeView.setData(with: entity.ticketNotice)
        self.organizerInfoView.setData(hostName: entity.hostName)
        self.concertDetailBackgroundView.setData(
            with: entity.posterURLPath,
            concertName: entity.title,
            ticketCount: entity.ticketInformations.count
        )
    }

    private func scrollToBottom() {
        self.scrollView.layoutIfNeeded()
        let scrollViewPaddingFromNavigationBar = CGFloat(16)
        let bottomOffset = CGPoint(
            x: 0,
            y: max(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + scrollViewPaddingFromNavigationBar, 0)
        )
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }

    private func calculateCollectionViewItemIndex() -> Int {
        let offSet = self.QRCodeCollectionView.contentOffset.x
        let width = self.QRCodeCollectionView.frame.width
        let horizontalCenter = width / 2
        let cellIndex = Int(offSet + horizontalCenter) / Int(width)

        return cellIndex
    }

    private func setfooterButton() {
        guard let ticketDetail = self.viewModel.output.fetchedTicketDetail.value else { return }
        let currentTicketIndex = self.QRCodePageControl.currentPage
        let currentTicket = ticketDetail.ticketInformations[currentTicketIndex]

        switch ticketDetail.showStatus {
        case .dayAfterShow:
            self.footerButton.isHidden = true
        case .dayBeforeShow:
            if ticketDetail.isGift {
                self.footerButton.setTitle("받은 선물 취소하기", for: .normal)
                self.footerButton.setUnderline(font: .pretendardR(14), textColor: .grey50)
            } else {
                self.footerButton.isHidden = true
            }
        case .onShowDate:
            self.footerButton.isHidden = currentTicket.ticketStatus != .notUsed
            self.footerButton.setTitle("입장 코드 입력하기", for: .normal)
            self.footerButton.setUnderline(font: .pretendardR(14), textColor: .grey50)
        }
    }

    // Rx로 뺄 계획!
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refetchTicketInformations()
    }

    func refetchTicketInformations() {
        self.viewModel.input.refreshControlEvent.onNext(())
    }

    private func makeButton(title: String, color: UIColor, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = .subhead1
        button.setTitleColor(titleColor, for: .normal)
        button.layer.cornerRadius = 4

        return button
    }

    func hideEntryCodeButton() {
        self.footerButton.isHidden = true
    }
}

extension TicketDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
