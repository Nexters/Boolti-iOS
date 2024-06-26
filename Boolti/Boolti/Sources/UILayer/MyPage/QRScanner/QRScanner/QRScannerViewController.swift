//
//  QRScannerViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import UIKit
import AVFoundation

import RxSwift

final class QRScannerViewController: BooltiViewController {

    // MARK: Properties

    typealias EntranceCode = String

    private let captureSession = AVCaptureSession()

    private let viewModel: QRScannerViewModel
    private let disposeBag = DisposeBag()
    private let entranceCodeViewControllerFactory: (EntranceCode) -> EntranceCodeViewController

    // MARK: UI Component

    private lazy var navigationBar = BooltiNavigationBar(type: .titleWithCloseButton(title: self.viewModel.qrScannerEntity.concertName))

    private let entranceCodeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "입장코드 보기"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey50
        config.imagePadding = 4

        let button = UIButton(configuration: config)
        button.setImage(.entranceCode, for: .normal)

        return button
    }()

    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey95
        return view
    }()

    private let qrCodeResponsePopUpView = QRCodeResponsePopUpView()

    // MARK: Init

    init(viewModel: QRScannerViewModel,
         entranceCodeViewControllerFactory: @escaping (EntranceCode) -> EntranceCodeViewController) {
        self.viewModel = viewModel
        self.entranceCodeViewControllerFactory = entranceCodeViewControllerFactory

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureQRScanner()
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension QRScannerViewController {

    private func bindOutputs() {
        self.viewModel.output.qrCodeValidationResponse
            .asDriver(onErrorJustReturn: .invalid)
            .drive(with: self) { owner, response in
                owner.qrCodeResponsePopUpView.setData(with: response)
                owner.qrCodeResponsePopUpView.isHidden = false

                UIView.animate(
                    withDuration: 0.3,
                    delay: 2,
                    animations: {
                        owner.qrCodeResponsePopUpView.alpha = 0
                    },
                    completion: { _ in
                        owner.qrCodeResponsePopUpView.alpha = 0.8
                        owner.qrCodeResponsePopUpView.isHidden = true
                    })
            }
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.entranceCodeButton.rx.tap
            .bind(with: self) { owner, _ in
                let viewController = owner.entranceCodeViewControllerFactory(owner.viewModel.qrScannerEntity.entranceCode)
                viewController.modalPresentationStyle = .overFullScreen
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureQRScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession.addInput(input)

            let output = AVCaptureMetadataOutput()
            self.captureSession.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]

            let rectConverted = self.configureVideoLayer()
            output.rectOfInterest = rectConverted

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func configureVideoLayer() -> CGRect {
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)

        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        let widthRatio: CGFloat = 0.7
        let heightRatio: CGFloat = 0.5

        let width = UIScreen.main.bounds.width * widthRatio
        let height = UIScreen.main.bounds.height * heightRatio

        let focusAreaRect = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: (UIScreen.main.bounds.height - height) / 2,
            width:  UIScreen.main.bounds.width * widthRatio,
            height: UIScreen.main.bounds.height * heightRatio
        )

        return videoLayer.metadataOutputRectConverted(fromLayerRect: focusAreaRect)
    }
}

// MARK: - UI

extension QRScannerViewController {

    private func configureUI() {
        self.view.addSubviews([
            self.navigationBar,
            self.qrCodeResponsePopUpView,
            self.bottomBackgroundView,
            self.entranceCodeButton,
        ])

        self.view.backgroundColor = .grey95
        self.qrCodeResponsePopUpView.isHidden = true
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.entranceCodeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
        }

        self.qrCodeResponsePopUpView.snp.makeConstraints { make in
            make.bottom.equalTo(self.entranceCodeButton.snp.top).offset(-44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        self.bottomBackgroundView.snp.makeConstraints { make in
            make.width.bottom.equalToSuperview()
            make.top.equalTo(self.entranceCodeButton.snp.top).offset(-20)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if presentedViewController == nil, let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        {
            guard let decodedCode = metadataObject.stringValue else {
                self.viewModel.output.qrCodeValidationResponse.accept(.invalid)
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.captureSession.stopRunning()
            self.viewModel.input.detectQRCode.accept(decodedCode)

            debugPrint("🚪 인식된 입장 코드: \(decodedCode) 🚪")

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.captureSession.startRunning()
            }
        }
    }
}
