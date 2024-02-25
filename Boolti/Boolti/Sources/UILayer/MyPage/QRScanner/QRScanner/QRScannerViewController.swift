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

    private lazy var navigationBar = BooltiNavigationBar(type: .qrScanner(concertName: self.viewModel.qrScannerEntity.concertName))

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
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video device found")
        }

        do {
            let cameraHeight = UIScreen.main.bounds.height - (self.navigationBar.statusBarHeight + 44) - 96
            let rectOfInterest = CGRect(x: 0,
                                        y: self.navigationBar.statusBarHeight + 44,
                                        width: UIScreen.main.bounds.width,
                                        height: cameraHeight)

            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]

            let rectConverted = configureVideoLayer(rectOfInterest: rectOfInterest)
            output.rectOfInterest = rectConverted

            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func configureVideoLayer(rectOfInterest: CGRect) -> CGRect {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        videoLayer.frame = rectOfInterest
        videoLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
}

// MARK: - UI

extension QRScannerViewController {

    private func configureUI() {
        self.view.addSubviews([self.navigationBar, self.entranceCodeButton, self.qrCodeResponsePopUpView])

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
            make.centerX.equalToSuperview()
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
