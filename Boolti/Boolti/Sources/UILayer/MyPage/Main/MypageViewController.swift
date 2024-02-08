//
//  MyPageViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class MyPageViewController: UIViewController {

    private let logoutViewControllerFactory: () -> LogoutViewController
    private let ticketReservationsViewControllerFactory: () -> TicketReservationsViewController
    private let qrScanViewControllerFactory: () -> QrScanViewController

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .home
        imageView.backgroundColor = .grey80
        imageView.clipsToBounds = true

        return imageView
    }()

    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "김불티 Kim Boolti"
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()

    private let profileEmailView: UILabel = {
        let label = UILabel()
        label.text = "boolti1234@gmail.com"
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    private let logoutNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey50)

        return button
    }()

    private let ticketingReservationsNavigationView = MypageContentView(title: "예매 내역")
    private let qrScanNavigationView = MypageContentView(title: "QR 스캔")

    override func viewWillLayoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    init(
        viewModel: MyPageViewModel,
        logoutViewControllerViewControllerFactory: @escaping () -> LogoutViewController,
        ticketReservationsViewControllerFactory: @escaping () -> TicketReservationsViewController,
        qrScanViewControllerFactory: @escaping () -> QrScanViewController
    ) {
        self.logoutViewControllerFactory = logoutViewControllerViewControllerFactory
        self.ticketReservationsViewControllerFactory = ticketReservationsViewControllerFactory
        self.qrScanViewControllerFactory = qrScanViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black100

        self.view.addSubviews([
            self.profileImageView,
            self.profileNameLabel,
            self.profileEmailView,
            self.ticketingReservationsNavigationView,
            self.qrScanNavigationView,
            self.logoutNavigationButton
        ])

        self.profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
        }

        self.profileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.profileImageView.snp.right).offset(12)
            make.top.equalTo(self.profileImageView.snp.top).offset(8)
        }

        self.profileEmailView.snp.makeConstraints { make in
            make.left.equalTo(self.profileNameLabel)
            make.top.equalTo(self.profileNameLabel.snp.bottom).offset(4)
        }

        self.ticketingReservationsNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(32)
        }

        self.qrScanNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.ticketingReservationsNavigationView.snp.bottom).offset(12)
        }

        self.logoutNavigationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }

    }
}
