//
//  QRReaderViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit
import AVFoundation

final class QRReaderViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange01
        setQRReader()
    }
}

extension QRReaderViewController {
    private func setQRReader() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video device found")
        }
        
        do {
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2,
                                        y: (UIScreen.main.bounds.height - 200) / 2,
                                        width: 200, height: 200)

            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]

            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            output.rectOfInterest = rectConverted
            
            setGuideCrossLineView(rectOfInterest: rectOfInterest)

            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoLayer)

        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    private func setGuideCrossLineView(rectOfInterest: CGRect) {
        let cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 5

        let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)

        setGuideCornerLine(from: upperLeftPoint, to: upperLeftPoint + CGPoint(x: cornerLength, y: 0), width: cornerLineWidth)
        setGuideCornerLine(from: upperLeftPoint, to: upperLeftPoint + CGPoint(x: 0, y: cornerLength), width: cornerLineWidth)

        setGuideCornerLine(from: upperRightPoint, to: upperRightPoint + CGPoint(x: -cornerLength, y: 0), width: cornerLineWidth)
        setGuideCornerLine(from: upperRightPoint, to: upperRightPoint + CGPoint(x: 0, y: cornerLength), width: cornerLineWidth)

        setGuideCornerLine(from: lowerRightPoint, to: lowerRightPoint + CGPoint(x: 0, y: -cornerLength), width: cornerLineWidth)
        setGuideCornerLine(from: lowerRightPoint, to: lowerRightPoint + CGPoint(x: -cornerLength, y: 0), width: cornerLineWidth)

        setGuideCornerLine(from: lowerLeftPoint, to: lowerLeftPoint + CGPoint(x: 0, y: -cornerLength), width: cornerLineWidth)
        setGuideCornerLine(from: lowerLeftPoint, to: lowerLeftPoint + CGPoint(x: cornerLength, y: 0), width: cornerLineWidth)
    }

    private func setGuideCornerLine(from startPoint: CGPoint, to endPoint: CGPoint, width: CGFloat) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = width

        view.layer.addSublayer(lineLayer)
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension QRReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if presentedViewController == nil,
           let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            captureSession.stopRunning()

            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "확인", message: stringValue, preferredStyle: .alert)
                let confirm = UIAlertAction(title: "닫기", style: .default) { _ in
                    DispatchQueue.global(qos: .background).async {
                        self.captureSession.startRunning()
                    }
                }
                alertController.addAction(confirm)
                self.present(alertController, animated: true)
            }
        }
    }
}
