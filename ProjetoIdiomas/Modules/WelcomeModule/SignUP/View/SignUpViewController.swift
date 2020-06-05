//
//  SignUpViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import FirebaseAuth
class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    ///sign with apple button
    let siwaButton = ASAuthorizationAppleIDButton()
    var currentNonce: String?
    
    var signInGoogleButton = GIDSignInButton()
    
    var presenter: SignUpViewToPresenter? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupSIWAButton()
        setupGoogleSignIn()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //removar objserver
        NotificationCenter.default.removeObserver(self, name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)

    }

    @IBAction func signUp(_ sender: Any) {
        errorLabel.isHidden = true
        presenter?.validateTextFields(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text)
    }
    

    @IBAction func singInWithEmail(_ sender: Any) {
    }
}



extension SignUpViewController: SignUpPresenterToView{
    
    
    func showAlertError(error msg: String) {
        let alert = UIAlertController(title: "Operation Failed", message: msg, preferredStyle: .alert)
        alert.isSpringLoaded = true
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateView(text: String) {
        errorLabel.text = text
        errorLabel.isHidden = false
    }
    
    
    
    
    
}


//MARK: -> Sign with Apple
extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding{
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    
    func setupSIWAButton(){
        
        /// set this so the button will use auto layout constraint
        siwaButton.translatesAutoresizingMaskIntoConstraints = false

        /// add the button to the view controller root view
        self.view.addSubview(siwaButton)

        /// set constraint
        NSLayoutConstraint.activate([
            siwaButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            siwaButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            siwaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70.0),
            siwaButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])

        /// the function that will be executed when user tap the button
        siwaButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }
    
    
    @objc func appleSignInTapped(){
        presenter?.authenticateWithApple(with: self)
    }
    
    
    
    ///quando for tratar log ouuut
    
    //quando o usuario deslogou vai ser chamada essa funça quando ele entrar
    @objc func appleIDStateDidRevoked(){
        // Make sure user signed in with Apple
//        if
//            let providerId = currentUser?.providerData.first?.providerID,
//            providerId == "apple.com" {
//            signOut()
//        }
    }
    
    //Handle Credential Revoke When App is Terminated
    func revoke(){
        // Retrieve user ID saved in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
            
            // Check Apple ID credential state
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { [unowned self]
                credentialState, error in
                
                switch(credentialState) {
                case .authorized:
                    break
                case .notFound,
                     .transferred,
                     .revoked:
                    // Perform sign out
                   // try? self.signOut()
                    break
                @unknown default:
                    break
                }
            })
        }
    }
    
}


extension SignUpViewController{
    
    func setupGoogleSignIn(){
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        /// set this so the button will use auto layout constraint
        signInGoogleButton.translatesAutoresizingMaskIntoConstraints = false

        /// add the button to the view controller root view
        self.view.addSubview(signInGoogleButton)

        /// set constraint
        NSLayoutConstraint.activate([
            signInGoogleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            signInGoogleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            signInGoogleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120.0),
            signInGoogleButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
   
}
