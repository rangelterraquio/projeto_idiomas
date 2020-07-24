//
//  SignInEmailPasswordViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class SignInEmailPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: SignInEmailPasswordPresenter? = nil
    var loadScreen: LoadingScreen?
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 109/255, alpha: 1.0)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logIn(_ sender: Any) {
        loadScreen = LoadingScreen(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
        self.view.addSubview(loadScreen!)
        presenter?.validateUser(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        presenter?.resetPassword(from: emailTextField.text)
    }
    
    func showAlertToResetPassword(){
        let alert = UIAlertController(title: "Reset Password", message: "Put your email for we send a reset email", preferredStyle: .alert)
        
        var textEmail: UITextField?
        
        let resetAction = UIAlertAction(title: "Send", style: .default) { (login) in
            
            if let email = textEmail?.text {
                self.presenter?.resetPassword(from: email)
            } else {
                print("No password")
            }
        }

        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }
        
        alert.addTextField { (passwordTextField) in
            textEmail = passwordTextField
            textEmail?.isSecureTextEntry = true
            textEmail?.placeholder = "Enter your email"
        }
        
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
                           
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

extension SignInEmailPasswordViewController: SignInEmailPasswordPresenterToView{
    
    func didSuccessfullyresetPasswordSent() {
        self.showAlertError(error: "An message was sent to your email to restart", title: "Email Sent")
    }
    
    
    func showError(error msg: String) {
        if let loadV = loadScreen{
            if let _ = loadV.superview{
                loadV.removeFromSuperview()
            }
        }
        self.showAlertError(error: msg, title: "Operation Failed")
    }
}
