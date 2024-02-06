//
//  TicketDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

import RxSwift
import RxCocoa

class TicketDetailViewController: BooltiViewController {

    private let ticketEntryCodeControllerFactory: () -> TicketEntryCodeViewController

    private let viewModel: TicketDetailViewModel
    private let ticketItem: TicketItem

    private let navigationBar = BooltiNavigationView(type: .ticketDetail)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
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

    private let entryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("입장 코드 입력하기", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey50)

        return button
    }()

    private lazy var ticketDetailView = TicketDetailView(item: self.ticketItem)
    private let reversalPolicyView = ReversalPolicyView()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureToastView(isButtonExisted: false)
        self.bindUIComponenets()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        ticketItem: TicketItem,
        viewModel: TicketDetailViewModel,
        ticketEntryCodeViewControllerFactory: @escaping () -> TicketEntryCodeViewController
    ) {
        self.ticketItem = ticketItem
        self.viewModel = viewModel
        self.ticketEntryCodeControllerFactory = ticketEntryCodeViewControllerFactory
        super.init()
    }

    private func configureUI() {
        self.view.backgroundColor = .black

        self.view.addSubviews([self.navigationBar, self.scrollView])
        self.scrollView.addSubview(self.contentStackView)
        self.entryCodeView.addSubview(self.entryCodeButton)

        self.contentStackView.setCustomSpacing(20, after: self.ticketDetailView)

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        self.entryCodeView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }

        self.entryCodeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.entryCodeButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }


        self.contentStackView.addArrangedSubviews([
            self.ticketDetailView,
            self.reversalPolicyView,
            self.entryCodeView
        ])
    }

    private func bindUIComponenets() {
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
                owner.showToast(message: "공연장 주소가 복사되었어요.")
            }
            .disposed(by: self.disposeBag)

        self.entryCodeButton.rx.tap
            .bind(with: self) { owner, _ in
                let viewController = owner.ticketEntryCodeControllerFactory()
                viewController.modalPresentationStyle = .overFullScreen
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        // 원래는 여기서 VM를 통해서 API 통신을 해서 받아오지만, 지금은 그냥 전에 넘어온 값으로 구현!.
    }

    private func scrollToBottom() {
        let scrollViewPaddingFromNavigationBar = CGFloat(16)
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollViewPaddingFromNavigationBar)

        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
}
