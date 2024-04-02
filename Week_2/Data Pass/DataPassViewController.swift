//
//  ViewController.swift
//  iOS_009_DataPass
//
//  Created by DREAMWORLD on 22/02/24.
//

import UIKit

class DataPassViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.isNavigationBarHidden = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
        
        tfName.delegate = self
        tfEmail.delegate = self
        tfPassword.delegate = self
    }
    
    @objc func tapView() {
        self.view.endEditing(true)
    }

    @IBAction func btnSignInClick(_ sender: UIButton) {
        
        if tfName.text == "" {
            showAlert("Enter Name")
        } else if tfEmail.text == "" {
            showAlert("Enter Email")
        } else if !isValidEmail(tfEmail.text!) {
            showAlert("Enter Valid Email Address")
        } else if tfPassword.text == "" {
            showAlert("Enter Password")
        } else if tfPassword.text?.count != 8 {
            showAlert("Password Must Contain 8 Characters")
        } else {
            let vc = dataPassStroyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
            vc.nameText = tfName.text!
            vc.emailText = tfEmail.text!
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func showAlert(_ message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        present(avc, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

