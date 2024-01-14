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

class FaceRecogViewController: BaseViewController {
    
    private var isUsingFrontCamera = true
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.navigationController?.popViewController(animated: true)
            }
            
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

extension FaceRecogViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
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
        
        detectFacesOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
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
    
    private func detectFacesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        // When performing latency tests to determine ideal detection settings, run the app in 'release'
        // mode to get accurate performance metrics.
        let options = FaceDetectorOptions()
        options.landmarkMode = .none
        options.contourMode = .all
        options.classificationMode = .none
        options.performanceMode = .fast
        let faceDetector = FaceDetector.faceDetector(options: options)
        weak var weakSelf = self
        faceDetector.process(image) { faces, error in
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.updatePreviewOverlayViewWithLastFrame()
            if let detectionError = error {
                print("Failed to detect faces with error: \(detectionError.localizedDescription).")
                return
            }
            
            if let faces = faces {
                for face in faces {
                    //                    let normalizedRect = CGRect(
                    //                        x: face.frame.origin.x / width,
                    //                        y: face.frame.origin.y / height,
                    //                        width: face.frame.size.width / width,
                    //                        height: face.frame.size.height / height
                    //                    )
                    //                    let standardizedRect = strongSelf.previewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect).standardized
                    //                    UIUtilities.addRectangle(
                    //                        standardizedRect,
                    //                        to: strongSelf.annotationOverlayView,
                    //                        color: UIColor.green
                    //                    )
                    strongSelf.addContours(for: face, width: width, height: height)
                }
            }
        }
    }
    
    private func addContours(for face: Face, width: CGFloat, height: CGFloat) {
        // Face
        if let faceContour = face.contour(ofType: .face) {
            for point in faceContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.blue,
                    radius: Constant.smallDotRadius
                )
            }
        }
        
        // Eyebrows
        if let topLeftEyebrowContour = face.contour(ofType: .leftEyebrowTop) {
            for point in topLeftEyebrowContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.orange,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let bottomLeftEyebrowContour = face.contour(ofType: .leftEyebrowBottom) {
            for point in bottomLeftEyebrowContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.orange,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let topRightEyebrowContour = face.contour(ofType: .rightEyebrowTop) {
            for point in topRightEyebrowContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.orange,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let bottomRightEyebrowContour = face.contour(ofType: .rightEyebrowBottom) {
            for point in bottomRightEyebrowContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.orange,
                    radius: Constant.smallDotRadius
                )
            }
        }
        
        // Eyes
        if let leftEyeContour = face.contour(ofType: .leftEye) {
            for point in leftEyeContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.cyan,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let rightEyeContour = face.contour(ofType: .rightEye) {
            for point in rightEyeContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.cyan,
                    radius: Constant.smallDotRadius
                )
            }
        }
        
        // Lips
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            for point in topUpperLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.red,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let bottomUpperLipContour = face.contour(ofType: .upperLipBottom) {
            for point in bottomUpperLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.red,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let topLowerLipContour = face.contour(ofType: .lowerLipTop) {
            for point in topLowerLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.red,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let bottomLowerLipContour = face.contour(ofType: .lowerLipBottom) {
            for point in bottomLowerLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.red,
                    radius: Constant.smallDotRadius
                )
            }
        }
        
        // Nose
        if let noseBridgeContour = face.contour(ofType: .noseBridge) {
            for point in noseBridgeContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constant.smallDotRadius
                )
            }
        }
        if let noseBottomContour = face.contour(ofType: .noseBottom) {
            for point in noseBottomContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                UIUtilities.addCircle(
                    atPoint: cgPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constant.smallDotRadius
                )
            }
        }
    }
    
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
    ) -> CGPoint {
        let cgPoint = CGPoint(x: point.x, y: point.y)
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
    
}

// MARK: - UIImage

extension UIImage {
    
    /// Creates and returns a new image scaled to the given size. The image preserves its original PNG
    /// or JPEG bitmap info.
    ///
    /// - Parameter size: The size to scale the image to.
    /// - Returns: The scaled image or `nil` if image could not be resized.
    public func scaledImage(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()?.data.flatMap(UIImage.init)
    }
    
    // MARK: - Private
    
    /// The PNG or JPEG data representation of the image or `nil` if the conversion failed.
    private var data: Data? {
#if swift(>=4.2)
        return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
#else
        return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
#endif  // swift(>=4.2)
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
