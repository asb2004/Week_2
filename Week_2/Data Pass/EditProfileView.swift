//
//  EditProfileView.swift
//  iOS_009_DataPass
//
//  Created by DREAMWORLD on 22/02/24.
//

import UIKit

protocol DataPassDelegate {
    func sendDataToProfileView(nameValue: String, emailValue: String)
}

class EditProfileView: UIViewController, UITextFieldDelegate {

    @IBOutlet var tfEditEmail: UITextField!
    @IBOutlet var tfEditName: UITextField!
    
    var emailText: String?
    var nameText: String?
    
    //Closure for data passing
    var dataPassClosure: ((String, String) -> Void)?
    
    //delegate property
    var delegate: DataPassDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfEditName.text = nameText
        tfEditEmail.text = emailText
        
        tfEditName.delegate = self
        tfEditEmail.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))

    }
    
    @objc func tapView() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        if let name = tfEditName.text, let email = tfEditEmail.text {
            
//MARK: Notificaiton center
//            let dataDic = ["name": name, "email": email]
//            navigationController?.popViewController(animated: true)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificaitonFromEditProfile"), object: nil, userInfo: dataDic)
            
            
//MARK: Data pass using Closure
//            dataPassClosure?(name, email)
//            navigationController?.popViewController(animated: true)
            
//MARK: Data pass using Protocol Delegate
            delegate?.sendDataToProfileView(nameValue: name, emailValue: email)
            navigationController?.popViewController(animated: true)
            
            
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
