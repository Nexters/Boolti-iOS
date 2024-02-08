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

class TicketDetailViewController: BooltiViewController {

    private let ticketEntryCodeControllerFactory: () -> TicketEntryCodeViewController

    private let viewModel: TicketDetailViewModel

    private let navigationBar = BooltiNavigationBar(type: .ticketDetail)

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

    private var ticketDetailView = TicketDetailView()
    private let reversalPolicyView = ReversalPolicyView()

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
        ticketEntryCodeViewControllerFactory: @escaping () -> TicketEntryCodeViewController
    ) {
        self.viewModel = viewModel
        self.ticketEntryCodeControllerFactory = ticketEntryCodeViewControllerFactory
        super.init()
    }

    private func configureUI() {
        self.view.backgroundColor = .black

        self.view.addSubviews([self.navigationBar, self.scrollView])
        self.scrollView.addSubview(self.contentStackView)
        self.entryCodeView.addSubview(self.entryCodeButton)

        self.configureConstraints()

        self.contentStackView.addArrangedSubviews([
            self.ticketDetailView,
            self.reversalPolicyView,
            self.entryCodeView
        ])

        self.contentStackView.setCustomSpacing(20, after: self.ticketDetailView)
    }

    private func configureConstraints() {

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
            .bind(with: self) { owner, ticketDetailItem in
                owner.ticketDetailView.setData(with: ticketDetailItem)
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
