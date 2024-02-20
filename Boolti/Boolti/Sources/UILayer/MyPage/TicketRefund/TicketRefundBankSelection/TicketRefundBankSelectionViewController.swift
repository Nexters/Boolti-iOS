//
//  TicketRefundBankSelectionViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketRefundBankSelectionViewController: BooltiViewController {

    private let disposeBag = DisposeBag()

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "은행 선택"
        label.textColor = .grey10
        label.font = .subhead2
        return label
    }()

    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.backgroundColor = .grey85
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TicketRefundBankCollectionViewCell.self, forCellWithReuseIdentifier: TicketRefundBankCollectionViewCell.className)
        return collectionView
    }()

    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
        gradient.colors = [UIColor.grey85.withAlphaComponent(0.0).cgColor, UIColor.grey85.cgColor]
        gradient.locations = [0.1, 0.7]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()

    private let finishSelectionButton = BooltiButton(title: "선택 완료하기")

    var isBankSelected: Bool = false
    var selectedItem: ((BankEntity) -> ())?

    // viewModel로 설정할 예정

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.configureConstraints()
        self.configureBottomSheet()
        self.bindUIComponents()
        self.bindOutputs()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 아래의 로직 리팩토링하기! -> 화면 네비게이션 로직 + ViewModel 생성
        guard let homeTabBarController = self.presentingViewController as? HomeTabBarController else { return }
        guard let rootviewController = homeTabBarController.children[2] as? UINavigationController else { return }
        guard let ticketRefundRequestViewController = rootviewController.viewControllers.filter({ $0 is TicketRefundRequestViewController
        })[0] as? TicketRefundRequestViewController else { return }

        ticketRefundRequestViewController.dimmedBackgroundView.isHidden = true
    }

    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.finishSelectionButton.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        self.sheetPresentationController?.detents = [.custom(resolver: { _ in
            return 647
        })]

        self.view.addSubviews([
            self.titleView,
            self.collectionView,
            self.finishSelectionButton,
            self.buttonBackgroundView
        ])
        self.titleView.addSubview(titleLabel)

        self.configureCollectionView()
    }

    private func configureCollectionView() {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {
        self.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, selectedIndexPath in
                owner.isBankSelected = true
                
                // TODO: 선택 완료했을 때만 넘어가야함
                owner.selectedItem?(BankEntity.all[selectedIndexPath.row])
                owner.updateCellUI(selectedIndexPath)

                if !owner.finishSelectionButton.isEnabled {
                    owner.finishSelectionButton.isEnabled.toggle()
                }
            }
            .disposed(by: self.disposeBag)

        self.finishSelectionButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func updateCellUI(_ selectedIndexPath: ControlEvent<IndexPath>.Element) {
        for item in 0..<self.collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            if let cell = self.collectionView.cellForItem(at: indexPath) as? TicketRefundBankCollectionViewCell {
                cell.isSelected = (indexPath == selectedIndexPath)
            }
        }
    }

    private func configureConstraints() {
        self.titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleView.snp.left).offset(24)
            make.bottom.equalTo(self.titleView.snp.bottom).offset(-12)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.finishSelectionButton.snp.top)
        }

        self.finishSelectionButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.finishSelectionButton.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    private func configureBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }

    private func bindOutputs() {
        Observable.of(BankEntity.all)
            .asObservable()
            .bind(to: self.collectionView.rx
                .items(cellIdentifier: TicketRefundBankCollectionViewCell.className, cellType: TicketRefundBankCollectionViewCell.self)
            ) { index, entity, cell in
                cell.setData(with: entity)
            }
            .disposed(by: self.disposeBag)
    }
}

extension TicketRefundBankSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = self.collectionView.frame.width

        let cellWidth = (collectionViewWidth - 20) / 3
        let cellHeight = cellWidth * 0.69

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? TicketRefundBankCollectionViewCell {
            if isBankSelected {
                cell.alpha = cell.isSelected ? 1.0 : 0.4
            }
        }
    }
}
