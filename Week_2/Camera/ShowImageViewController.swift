//
//  ShowImageViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 26/02/24.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imageIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnTap = true

        imageView.image = UIImage(data: capturedImages[imageIndex])
        // Do any additional setup after loading the view.
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func swipeGestureAction(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if imageIndex > 0 {
                    imageIndex -= 1
                    imageView.image = UIImage(data: capturedImages[imageIndex])
                }
            
            case .left:
                if imageIndex < capturedImages.count - 1 {
                    imageIndex += 1
                    imageView.image = UIImage(data: capturedImages[imageIndex])
                }
                
            default:
                break
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
