//
//  ViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 23/02/24.
//

import UIKit
import AVKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageVIew: UIImageView!
    @IBOutlet var playButton: UIImageView!
    
    var videoURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = true
        playButton.isUserInteractionEnabled = true
        playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playButtonTapped)))
    }

    @IBAction func cameraTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.movie","public.image"]
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoLibraryTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectVideoTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            imageVIew.image = image
            playButton.isHidden = true
        } else if let image = info[.editedImage] as? UIImage {
            imageVIew.image = image
            playButton.isHidden = true
        } else if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            imageVIew.image = getThumbnailImageFromURL(url: url)
            videoURL = url
            playButton.isHidden = false
        } else {
            print("no image found")
        }
    }
    
    @IBAction func customCameraTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "customCameraView", sender: nil)
    }
    
    @objc func playButtonTapped() {
        playVideo(url: videoURL)
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }

    func getThumbnailImageFromURL(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch {
            fatalError("error")
        }
    }
}

