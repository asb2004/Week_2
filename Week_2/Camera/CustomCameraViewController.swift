//
//  CustomCameraViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 26/02/24.
//

import UIKit
import AVFoundation
import AVKit

var capturedImages: [Data] = []
var videoURLs: [URL] = []

class CustomCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    var segmentURLs = [URL]()

    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet var captureImageVIew: UIImageView!
    @IBOutlet var previewView: UIView!
    @IBOutlet var btncCaptureImage: UIButton!
    @IBOutlet var touchView: UIButton!
    @IBOutlet var autoTorchView: UIButton!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var recordVideoButton: UIButton!
    @IBOutlet var timerForRecording: UILabel!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoOutput: AVCaptureMovieFileOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var audioDevice: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    var audioInput: AVCaptureInput!
    
    var timer: Timer!
    
    var data: Data!
    
    var takePicture = false
    var isRecordingOn = false
    var isBackOn = true
    var isTorchOn = false
    var autoTorchOn = false
    var isVideoPause = false
    
    var outputURL: URL?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBack = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backGesture))
        leftBack.edges = .left
        view.addGestureRecognizer(leftBack)
    }
    
    @objc func backGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isBackOn = true
        autoTorchOn = false
        autoTorchView.configuration?.baseForegroundColor = .white
        btncCaptureImage.layer.borderColor = UIColor.white.cgColor
        btncCaptureImage.layer.cornerRadius = btncCaptureImage.frame.width / 2
        btncCaptureImage.layer.borderWidth = 5.0
        
        recordVideoButton.layer.borderColor = UIColor.white.cgColor
        recordVideoButton.layer.cornerRadius = recordVideoButton.frame.width / 2
        recordVideoButton.layer.borderWidth = 5.0

        let imageTappedGesture = UITapGestureRecognizer(target: self, action: #selector(captureImageVIewTapped))
        captureImageVIew.isUserInteractionEnabled = true
        captureImageVIew.addGestureRecognizer(imageTappedGesture)
        
        setUpAndStartSession()
        
    }
    
    
    @objc func captureImageVIewTapped() {
        
        let vc = cameraStoryboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func autoTorchTapped(_ sender: Any) {
        if isBackOn {
            if autoTorchOn {
                autoTorchOn = false
                autoTorchView.configuration?.baseForegroundColor = .white
            } else {
                autoTorchOn = true
                autoTorchView.configuration?.baseForegroundColor = .systemYellow
            }
        }
    }
    
    
    func setUpAndStartSession() {
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        setUpInputs()
        setUpLivePreview()
        
        stillImageOutput = AVCapturePhotoOutput()
        videoOutput = AVCaptureMovieFileOutput()
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    func setUpInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            fatalError("no back camera")
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("no back camera")
        }
        
        guard let binput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not add back camera as input device")
        }
        backInput = binput
        
        guard let finput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not add front camrea as input device")
        }
        frontInput = finput
        
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera")
        }
        
        if !captureSession.canAddInput(frontInput) {
            fatalError("could not add front camera")
        }
        
        if let device = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified) {
            audioDevice = device
        }
        
        guard let ainput = try? AVCaptureDeviceInput(device: audioDevice) else {
            fatalError("could not add audio device as input")
        }
        audioInput = ainput
        
        if !captureSession.canAddInput(audioInput) {
            fatalError("could not add audio device")
        }
        
        captureSession.addInput(backInput)
        captureSession.addInput(audioInput)
    }
    
    func setUpLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    

   
    @IBAction func captureImageTapped(_ sender: Any) {
        touchView.configuration?.baseForegroundColor = .white
        if autoTorchOn {
            do{
                if isBackOn {
                    try backCamera.lockForConfiguration()
                    backCamera.torchMode = .on
                    backCamera.unlockForConfiguration()
                    
                    touchView.configuration?.baseForegroundColor = .white
                }
            } catch {
                print("torch not found")
            }
        }
        
        let settings = AVCapturePhotoSettings()
        if let photoPrivewType = settings.availablePreviewPhotoPixelFormatTypes.first {
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPrivewType]
        }
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        if isRecordingOn {
            recordVideoButton.configuration?.baseForegroundColor = .white
            videoOutput.stopRecording()
            touchView.configuration?.baseForegroundColor = .white
            do{
                try backCamera.lockForConfiguration()
                backCamera.torchMode = .off
            } catch {
                print(error)
            }
            isRecordingOn = false
            timer.invalidate()
            timerForRecording.text = "00:00:00"
        } else {
            recordVideoButton.configuration?.baseForegroundColor = .red
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output\(videoURLs.count + 1).mp4")
            videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
            isRecordingOn = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeTimerLabel() {
        let totalSec = CMTimeGetSeconds(videoOutput.recordedDuration)
        let hour = Int(totalSec / 3600)
        let min = Int(totalSec.truncatingRemainder(dividingBy: 3600) / 60)
        let sec = Int(totalSec.truncatingRemainder(dividingBy: 60))
        
        //timerForRecording.text = "\(hour):\(min):\(sec)"
        timerForRecording.text = String(format: "%0.2d:%0.2d:%0.2d", hour, min, sec)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let image = getThumbnailImageFromURL(url: outputFileURL) {
            captureImageVIew.image = image
            videoURLs.insert(outputFileURL, at: 0)
        }
        
    }
    
    func getThumbnailImageFromURL(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            let image = UIImage(cgImage: thumbnailImage, scale: 1.0, orientation: .right)
            return image
        } catch {
            fatalError("error")
        }
    }
    
    
    @IBAction func tourchTapped(_ sender: UIButton) {
        do {
            try backCamera.lockForConfiguration()
            
            if isBackOn {
                if isTorchOn {
                    backCamera.torchMode = .on
                    isTorchOn = false
                    touchView.configuration?.baseForegroundColor = .systemYellow
                } else {
                    backCamera.torchMode = .off
                    isTorchOn = true
                    touchView.configuration?.baseForegroundColor = .white
                }
            }
            
            backCamera.unlockForConfiguration()
        } catch {
            print("Touch cannot be used")
        }
    }
    
    @IBAction func rotateCameraTapped(_ sender: UIButton) {
        if isBackOn {
            touchView.configuration?.baseForegroundColor = .white
            autoTorchView.configuration?.baseForegroundColor = .white
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            isBackOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            isBackOn = true
        }
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        //touchView.isHidden = true
        videoButton.isHidden = true
        photoButton.isHidden = false
        recordVideoButton.isHidden = false
        btncCaptureImage.isHidden = true
        timerForRecording.isHidden = false
    }
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        //touchView.isHidden = false
        videoButton.isHidden = false
        photoButton.isHidden = true
        btncCaptureImage.isHidden = false
        recordVideoButton.isHidden = true
        timerForRecording.isHidden = true
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        do{
            try backCamera.lockForConfiguration()
            backCamera.torchMode = .off
            backCamera.unlockForConfiguration()
        } catch {
            print("torch not found")
        }
        
        data = imageData
        capturedImages.insert(imageData, at: 0)
        captureImageVIew.image = UIImage(data: data)
        
        if !isBackOn {
            let image = UIImage(cgImage: (captureImageVIew.image?.cgImage)!, scale: 1.0, orientation: .leftMirrored)
            captureImageVIew.image = image
            capturedImages.remove(at: 0)
            capturedImages.insert((captureImageVIew.image?.jpegData(compressionQuality: 1))!, at: 0)
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    
}
