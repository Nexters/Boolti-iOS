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
    private var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    private lazy var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    private var backCameraInput: AVCaptureDeviceInput!
    private var frontCameraInput: AVCaptureDeviceInput!
    private let notificationHaptic = UINotificationFeedbackGenerator()

    private let viewModel: QRScannerViewModel
    private let disposeBag = DisposeBag()
    private let entranceCodeViewControllerFactory: (EntranceCode) -> EntranceCodeViewController

    // MARK: UI Component

    private lazy var navigationBar = BooltiNavigationBar(type: .qrScanner(title: self.viewModel.qrScannerEntity.concertName))
    
    private let entranceDescriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey50
        label.text = "QR 코드가 인식되지 않을 경우 티켓 화면 하단의\n’입장 코드 입력하기’에 아래 입장코드를 입력해 주세요."
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()

    private let entranceCodeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "입장코드 보기"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey30
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
                switch response {
                case .invalid, .isAlreadyUsed:
                    owner.notificationHaptic.notificationOccurred(.error)
                case .notToday:
                    owner.notificationHaptic.notificationOccurred(.warning)
                case .valid:
                    owner.notificationHaptic.notificationOccurred(.success)
                }
                
                owner.qrCodeResponsePopUpView.setData(with: response)
                owner.qrCodeResponsePopUpView.isHidden = false

                UIView.animate(
                    withDuration: 0.3,
                    delay: 1.5,
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
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didCameraButtonTap()
            .emit(with: self) { owner, _ in
                owner.captureSession.beginConfiguration()
                if owner.captureSession.inputs[0] == owner.backCameraInput {
                    owner.captureSession.removeInput(owner.backCameraInput)
                    owner.captureSession.addInput(owner.frontCameraInput)
                } else if owner.captureSession.inputs[0] == owner.frontCameraInput {
                    owner.captureSession.removeInput(owner.frontCameraInput)
                    owner.captureSession.addInput(owner.backCameraInput)
                }
                owner.captureSession.commitConfiguration()
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
        guard let backCamera = self.backCamera,
              let frontCamera = self.frontCamera else { return }

        do {
            self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            self.captureSession.addInput(backCameraInput)

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
            self.entranceDescriptionLabel,
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalToSuperview()
        }
        
        self.entranceDescriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.entranceCodeButton.snp.top).offset(-12)
            make.centerX.equalToSuperview()
        }

        self.qrCodeResponsePopUpView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.bottomBackgroundView.snp.top)
        }

        self.bottomBackgroundView.snp.makeConstraints { make in
            make.width.bottom.equalToSuperview()
            make.top.equalTo(self.entranceDescriptionLabel.snp.top).offset(-20)
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

            self.captureSession.stopRunning()
            self.viewModel.input.detectQRCode.accept(decodedCode)

            debugPrint("🚪 인식된 입장 코드: \(decodedCode) 🚪")

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.captureSession.startRunning()
            }
        }
    }
}
