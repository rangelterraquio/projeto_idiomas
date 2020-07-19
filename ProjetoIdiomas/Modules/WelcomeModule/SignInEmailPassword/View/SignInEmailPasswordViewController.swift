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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 109/255, alpha: 1.0)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logIn(_ sender: Any) {
        presenter?.validateUser(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        presenter?.resetPassword(from: emailTextField.text)
    }
    
}

extension SignInEmailPasswordViewController: SignInEmailPasswordPresenterToView{
    
    func didSuccessfullyresetPasswordSent() {
        self.showAlertError(error: "An message was sent to your email to restart", title: "Email Sent")
    }
    
    
    func showError(error msg: String) {
        self.showAlertError(error: msg, title: "Operation Failed")
    }
}
