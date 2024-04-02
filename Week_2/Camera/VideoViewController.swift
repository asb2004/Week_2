//
//  VideoViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 27/02/24.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! CustomVideeCollectionViewCell
        if let image = getThumbnailImageFromURL(url: videoURLs[indexPath.row]) {
            cell.videoThumbnailView.image = image
        }
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = cameraStoryboard.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
        vc.urlIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }

}
