//
//  CameraFaceViewController.swift
//  CinemaTix
//
//  Created by Eky on 04/12/23.
//

import UIKit
import AVFoundation
import CoreVideo
import CoreGraphics
import MLImage
import MLKit

class PayViewController: BaseViewController {
    
    private var isUsingFrontCamera = false
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    
    private lazy var previewOverlayView: UIImageView = {
        
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    let cameraView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let _ = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first {
            
            view.addSubview(cameraView)
            cameraView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(self.view)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            setUpPreviewOverlayView()
            setUpAnnotationOverlayView()
            setUpCaptureSessionOutput()
            setUpCaptureSessionInput()
            
            startSession()
            
        } else {
            
            self.view.backgroundColor = .systemGroupedBackground
            let label = UILabel()
            let icon = UIImageView(image: UIImage(systemName: "camera.fill"))
            icon.tintColor = .label
            label.text = "No Camera"
            label.textAlignment = .center
            self.view.addSubview(label)
            self.view.addSubview(icon)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            icon.snp.makeConstraints { make in
                make.height.equalTo(32)
                make.width.equalTo(40)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(label.snp.top).offset(-16)
            }
        }
    }
#if !targetEnvironment(simulator)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.frame
    }
#endif
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession()
    }
    
    private func startSession() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.stopRunning()
        }
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        previewOverlayView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(cameraView)
        }
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        annotationOverlayView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(cameraView)
        }
    }
    
    private func setUpCaptureSessionInput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            let cameraPosition: AVCaptureDevice.Position = strongSelf.isUsingFrontCamera ? .front : .back
            guard let device = strongSelf.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                strongSelf.captureSession.beginConfiguration()
                let currentInputs = strongSelf.captureSession.inputs
                for input in currentInputs {
                    strongSelf.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard strongSelf.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                strongSelf.captureSession.addInput(input)
                strongSelf.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func setUpCaptureSessionOutput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.beginConfiguration()
            strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            output.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
            
            guard strongSelf.captureSession.canAddOutput(output) else {
                print("Failed to add capture session output.")
                return
            }
            strongSelf.captureSession.addOutput(output)
            strongSelf.captureSession.commitConfiguration()
        }
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
    
    private func rotate(_ view: UIView, orientation: UIImage.Orientation) {
        var degree: CGFloat = 0.0
        switch orientation {
        case .up, .upMirrored:
            degree = 90.0
        case .rightMirrored, .left:
            degree = 180.0
        case .down, .downMirrored:
            degree = 270.0
        case .leftMirrored, .right:
            degree = 0.0
        default:
            degree = 0.0
        }
        
        view.transform = CGAffineTransform.init(rotationAngle: degree * 3.141592654 / 180)
    }
}

extension PayViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = UIUtilities.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        visionImage.orientation = orientation
        
        guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
            print("Failed to create MLImage from sample buffer.")
            return
        }
        inputImage.orientation = orientation
        
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        scanBarcodesOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
        guard let imageBuffer = imageBuffer else {
            return
        }
        let orientation: UIImage.Orientation = isUsingFrontCamera ? .leftMirrored : .right
        let image = UIUtilities.createUIImage(from: imageBuffer, orientation: orientation)
        previewOverlayView.image = image
    }
    
    private func updatePreviewOverlayViewWithLastFrame() {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return
        }
        self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
        self.removeDetectionAnnotations()
    }
    
    private func scanBarcodesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        // Define the options for a barcode detector.
        let format = BarcodeFormat.all
        let barcodeOptions = BarcodeScannerOptions(formats: format)
        
        // Create a barcode scanner.
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        var barcodes: [Barcode] = []
        var scanningError: Error?
        do {
            barcodes = try barcodeScanner.results(in: image)
        } catch let error {
            scanningError = error
        }
        weak var weakSelf = self
        DispatchQueue.main.sync {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.updatePreviewOverlayViewWithLastFrame()
            
            if let scanningError = scanningError {
                print("Failed to scan barcodes with error: \(scanningError.localizedDescription).")
                return
            }
            guard !barcodes.isEmpty else {
                print("Barcode scanner returrned no results.")
                return
            }
            for barcode in barcodes {
                let normalizedRect = CGRect(
                    x: barcode.frame.origin.x / width,
                    y: barcode.frame.origin.y / height,
                    width: barcode.frame.size.width / width,
                    height: barcode.frame.size.height / height
                )
                let convertedRect = strongSelf.previewLayer.layerRectConverted(
                    fromMetadataOutputRect: normalizedRect
                )
                UIUtilities.addRectangle(
                    convertedRect,
                    to: strongSelf.annotationOverlayView,
                    color: UIColor.green
                )
                let label = UILabel(frame: convertedRect)
                label.text = barcode.displayValue
                label.adjustsFontSizeToFitWidth = true
                strongSelf.rotate(label, orientation: image.orientation)
                strongSelf.annotationOverlayView.addSubview(label)
            }
        }
    }

}

// MARK: - Constants

private enum Constant {
    static let jpegCompressionQuality: CGFloat = 0.8
    static let alertControllerTitle = "Vision Detectors"
    static let alertControllerMessage = "Select a detector"
    static let cancelActionTitleText = "Cancel"
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let noResultsMessage = "No Results"
    static let localModelFile = (name: "bird", type: "tflite")
    static let labelConfidenceThreshold = 0.75
    static let smallDotRadius: CGFloat = 4.0
    static let lineWidth: CGFloat = 3.0
    static let originalScale: CGFloat = 1.0
    static let padding: CGFloat = 10.0
    static let resultsLabelHeight: CGFloat = 200.0
    static let resultsLabelLines = 5
    static let imageLabelResultFrameX = 0.4
    static let imageLabelResultFrameY = 0.1
    static let imageLabelResultFrameWidth = 0.5
    static let imageLabelResultFrameHeight = 0.8
    static let segmentationMaskAlpha: CGFloat = 0.5
}
