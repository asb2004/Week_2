//
//  ProfileView.swift
//  iOS_009_DataPass
//
//  Created by DREAMWORLD on 22/02/24.
//

import UIKit

class ProfileView: UIViewController, DataPassDelegate {
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    
    var emailText: String?
    var nameText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.isNavigationBarHidden = true
        
        if let name = nameText, let email = emailText {
            lblName.text = "Name : \(name)"
            lblEmail.text = "Email : \(email)"
        }
        
        //MARK: Notification center notify
//        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived(_:)), name: NSNotification.Name(rawValue: "notificaitonFromEditProfile"), object: nil)
    }
    
    
    @objc func dataReceived(_ notification: NSNotification) {
        if let name = notification.userInfo?["name"], let email = notification.userInfo?["email"] {
            lblName.text = "Name : \(name)"
            lblEmail.text = "Email : \(email)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditProfileView {
            if let name = nameText, let email = emailText {
                vc.nameText = name
                vc.emailText = email
            }
            
            //MARK: Assign this view controller to destination view delegate property
            vc.delegate = self
            
            //MARK: Data Receive using Closure
//            vc.dataPassClosure = { (name, email) in
//                self.nameText = name
//                self.emailText = email
//                self.lblName.text = "Name : \(name)"
//                self.lblEmail.text = "Email : \(email)"
//            }
        }
    }
    //MARK: Data receive using protocol delegate
    func sendDataToProfileView(nameValue: String, emailValue: String) {
        self.nameText = nameValue
        self.emailText = emailValue
        self.lblName.text = "Name : \(nameValue)"
        self.lblEmail.text = "Email : \(emailValue)"
    }

}
