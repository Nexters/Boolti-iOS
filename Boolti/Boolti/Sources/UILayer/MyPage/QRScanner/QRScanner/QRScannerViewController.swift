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

    private let captureSession = AVCaptureSession()
    
    private let viewModel: QRScannerViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private lazy var navigationBar = BooltiNavigationBar(type: .qrScanner(concertName: self.viewModel.concertName))
    
    // MARK: Init

    init(viewModel: QRScannerViewModel) {
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
        self.bindNavigationBar()
        self.configureQRScanner()
        self.configureToastView(isButtonExisted: false)
    }
}

// MARK: - Methods

extension QRScannerViewController {

    private func bindNavigationBar() {
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureQRScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video device found")
        }

        do {
            let cameraHeight = 628 * UIScreen.main.bounds.height / 812
            let rectOfInterest = CGRect(x: 0,
                                        y: (UIScreen.main.bounds.height - cameraHeight) / 2,
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
        self.view.addSubviews([self.navigationBar])

        self.view.backgroundColor = .grey95
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if presentedViewController == nil,
           let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            self.captureSession.stopRunning()

            DispatchQueue.main.async {
                self.showToast(message: stringValue)
                self.captureSession.startRunning()
            }
        }
    }
}
