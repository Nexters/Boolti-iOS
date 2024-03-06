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

    typealias TicketID = String
    typealias ConcertID = String
    typealias QRCodeImage = UIImage
    typealias TicketName = String

    private let ticketEntryCodeControllerFactory: (TicketID, ConcertID) -> TicketEntryCodeViewController
    private let qrExpandViewControllerFactory: (QRCodeImage, TicketName) -> QRExpandViewController
    private let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController

    private let viewModel: TicketDetailViewModel

    private let navigationBar = BooltiNavigationBar(type: .backButton)

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

    private let entryCodeView: UIView = {
        let view = UIView()
        return view
    }()

    let entryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("입장 코드 입력하기", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey50)

        return button
    }()

    private var ticketDetailView = TicketDetailView()
    private let reversalPolicyView = ReversalPolicyView()
    private let blankSpaceView = UIView()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.configureUI()
        self.configureToastView(isButtonExisted: false)
        self.configureLoadingIndicatorView()
        self.bindUIComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        viewModel: TicketDetailViewModel,
        ticketEntryCodeViewControllerFactory: @escaping (TicketID, ConcertID) -> TicketEntryCodeViewController,
        qrExpandViewControllerFactory: @escaping (QRCodeImage, TicketName) -> QRExpandViewController,
        concertDetailViewControllerFactory: @escaping (Int) -> ConcertDetailViewController
    ) {
        self.viewModel = viewModel
        self.ticketEntryCodeControllerFactory = ticketEntryCodeViewControllerFactory
        self.qrExpandViewControllerFactory = qrExpandViewControllerFactory
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory
        super.init()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95

        self.view.addSubviews([self.navigationBar, self.scrollView])
        self.scrollView.addSubviews([
            self.refreshControl,
            self.contentStackView
        ])
        self.entryCodeView.addSubview(self.entryCodeButton)


        self.contentStackView.addArrangedSubviews([
            self.ticketDetailView,
            self.reversalPolicyView,
            self.entryCodeView,
            self.blankSpaceView
        ])

        self.contentStackView.setCustomSpacing(20, after: self.ticketDetailView)
        self.configureConstraints()
    }

    private func configureConstraints() {

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(29)
        }

        self.ticketDetailView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        self.entryCodeView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }

        self.entryCodeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(60)
        }

        self.blankSpaceView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

    }

    private func bindUIComponents() {
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

        self.ticketDetailView.didCopyAddressButtonTap
            .bind(with: self) { owner, _ in
                UIPasteboard.general.string = owner.viewModel.output.fetchedTicketDetail.value?.location
                owner.showToast(message: "공연장 주소가 복사되었어요")
            }
            .disposed(by: self.disposeBag)

        self.ticketDetailView.didShowConcertDetailButtonTap
            .bind(with: self) { owner, _ in
                guard let concertId = owner.viewModel.output.fetchedTicketDetail.value?.concertID else { return }
                let viewController = owner.concertDetailViewControllerFactory(concertId)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)

        self.ticketDetailView.ticketDetailInformationView.qrCodeImageView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                guard let ticketDetail = owner.viewModel.output.fetchedTicketDetail.value else { return }
                let qrCodeImage = ticketDetail.qrCode
                let ticketName = ticketDetail.ticketName

                let viewController = owner.qrExpandViewControllerFactory(qrCodeImage, ticketName)
                viewController.modalPresentationStyle = .overFullScreen
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)

        self.entryCodeButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let ticketDetail = owner.viewModel.output.fetchedTicketDetail.value else { return }
                let ticketID = String(ticketDetail.ticketID)
                let concertID = String(ticketDetail.concertID)

                let viewController = owner.ticketEntryCodeControllerFactory(ticketID, concertID)
                viewController.modalPresentationStyle = .overCurrentContext
                owner.definesPresentationContext = true
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindInput() {
        self.rx.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.onNext(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.fetchedTicketDetail
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(with: self) { owner, ticketDetailItem in
                guard let ticketDetailItem else { return }
                owner.ticketDetailView.setData(with: ticketDetailItem)
                
                if ticketDetailItem.usedAt != nil {
                    owner.entryCodeButton.isHidden = true
                } else {
                    // 오늘 공연 여부에 따라 숨김 처리
                    owner.entryCodeButton.isHidden = ticketDetailItem.date.formatToDate().getBetweenDay(to: Date()) != 0
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.isLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(self.isLoading)
            .disposed(by: self.disposeBag)
    }

    private func scrollToBottom() {
        let scrollViewPaddingFromNavigationBar = CGFloat(16)
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollViewPaddingFromNavigationBar)

        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
}

extension TicketDetailViewController {
    // Rx로 뺄 계획!
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.input.refreshControlEvent.onNext(())
    }
}
