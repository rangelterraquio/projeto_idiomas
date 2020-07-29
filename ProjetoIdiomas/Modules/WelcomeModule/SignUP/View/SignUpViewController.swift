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

    @IBOutlet weak var signUPButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signGoogle: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
//    @IBOutlet weak var signInButton: GIDSignInButton!
    ///sign with apple button
    let siwaButton = ASAuthorizationAppleIDButton()
    var currentNonce: String?
    
    var signInGoogleButton = GIDSignInButton()
    
    var presenter: SignUpViewToPresenter? = nil
    
    var loadScreen: LoadingScreen!
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        setupSIWAButton()
        setupGoogleSignIn()
//        setupButtons()
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //removar objserver
        NotificationCenter.default.removeObserver(self, name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)

    }

    @IBAction func signUp(_ sender: Any) {
        loadScreen = LoadingScreen(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
        self.view.addSubview(loadScreen)
        errorLabel.isHidden = true
        presenter?.validateTextFields(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text)
    }
    

    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func singInWithEmail(_ sender: Any) {
        presenter?.signInWithEmail()
    }
}



extension SignUpViewController: SignUpPresenterToView{
    func updateViewWithLoading() {
        loadScreen = LoadingScreen(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
        self.view.addSubview(loadScreen)
    }
    
    
    
    func showAlertError(error msg: String) {
        if let lScreen = loadScreen{
            lScreen.removeFromSuperview()
        }
        self.showAlertError(error: msg, title: "Operation Failed")
    }
    
    func updateView(text: String) {
        if let lScreen = loadScreen{
            lScreen.removeFromSuperview()
        }
        errorLabel.text = text
        errorLabel.isHidden = false
    }
    
    
    
    
    
}
extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        siwaButton.cornerRadius = 20
        /// add the button to the view controller root view
        self.view.addSubview(siwaButton)

        /// set constraint
        NSLayoutConstraint.activate([
            siwaButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 1),
            siwaButton.centerYAnchor.constraint(equalTo: signUPButton.bottomAnchor, constant: 30),
            
            siwaButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.724638),
            siwaButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.045)
//            siwaButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
//            siwaButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
//            siwaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70.0),
//            siwaButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.724638),
//            siwaButton.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.0390625)
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
//        if let providerId = currentUser?.providerData.first?.providerID,
//            providerId == "apple.com" {
//            signOut()
//        }
    }
    
    //Handle Credential Revoke When App is Terminated
    func revoke(){
        // Retrieve user ID saved in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
            
            // Check Apple ID credential state
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
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
    
    func setupButtons(){
//        let width = (siwaButton.frame.size.width) * siwaButton.contentScaleFactor
//        let height = (siwaButton.frame.size.height) * UIScreen.main.scale
//        signUPButton.frame.size = CGSize(width: width, height: height)
//        logInButton.frame.size = CGSize(width: width, height: height)
    }
    
    func setupGoogleSignIn(){
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        /// set this so the button will use auto layout constraint
//        signInGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        signGoogle.translatesAutoresizingMaskIntoConstraints = false
        signGoogle.layer.cornerRadius = 20
        /// add the button to the view controller root view
//        self.view.addSubview(signInGoogleButton)

        /// set constraint
        NSLayoutConstraint.activate([
            signGoogle.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 1),
            signGoogle.centerYAnchor.constraint(equalTo: siwaButton.bottomAnchor, constant: 30),
            
            signGoogle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.724638),// 0.0390625
            signGoogle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.045)
        ])
        
        
    }
    
   
}
