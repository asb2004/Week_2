//
//  ViewController.swift
//  Week_2
//
//  Created by DREAMWORLD on 19/03/24.
//

import UIKit

let storyBoard = UIStoryboard(name: "tabBar", bundle: nil)
let dataPassStroyboard = UIStoryboard(name: "dataPass", bundle: nil)
let cameraStoryboard = UIStoryboard(name: "camera", bundle: nil)

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Week 2"
    }

    @IBAction func tabberDemoTapped(_ sender: UIButton) {
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dataPassTapped(_ sender: UIButton) {
        let vc = dataPassStroyboard.instantiateViewController(withIdentifier: "DataPassViewController") as! DataPassViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        let vc = cameraStoryboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

