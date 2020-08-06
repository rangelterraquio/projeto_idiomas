//
//  ReautheticationScreenViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth

class ReautheticationScreenViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordEmailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signGoogle: UIButton!
    let siwaButton = ASAuthorizationAppleIDButton()
    var currentNonce: String?
    
    var stateController: StateController!
    var signUpAPI: SignUpAPI!
    var delegate: ReAutheticationRouterDelegate? = nil
    
    @IBOutlet weak var backgroundImage: UIImageView!
    var loadScreen: LoadingScreen!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordEmailTextField.delegate = self
        setupSIWAButton()
        setupGoogleSignIn()
        
        
        
        let imageName = UIScreen.main.bounds.height != 736 ?  "fundoInicio": "fundoOnboard2-iphone8"
        backgroundImage.image = UIImage(named: imageName)
    }


    @IBAction func logIn(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordEmailTextField.text else {
            self.showAlert(error: "email or password invalid", title: "Operation Failed")
            return
        }
        updateViewWithLoading()
        signUpAPI.signWithEmail(email: email, password: password) { (result) in
            switch result{
            case .failure(let errorCode):
                self.showAlert(error: errorCode.errorMessage, title: "Operation Failed")
            case .success(_):
                self.delegate?.deleteAccount()
            }
        }
       
    }
    
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}


extension ReautheticationScreenViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: -> Sign with Apple
extension ReautheticationScreenViewController: ASAuthorizationControllerPresentationContextProviding{
    
    
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
            siwaButton.centerYAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 30),
            
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
        signUpAPI.appleSignInCalled(from: self)
//        presenter?.authenticateWithApple(with: self)
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


extension ReautheticationScreenViewController: ReautheticationDelegate{
    
    
    func didAuthetication(crendentials: AuthCredential?) {
        guard let cred = crendentials else {
            self.showAlert(error: "Something goes wrong", title: "Operation Failed")
            return
        }
        stateController.deleteUserAccount(crendentials: cred) { (result) in
            if let lScreen = self.loadScreen{
                lScreen.removeFromSuperview()
            }
            switch result{
            case .operationFailed:
                self.showAlert(error: "Something goes wrong", title: "Operation Failed")
            case .none:
                self.signUpAPI.reAutheticationDelegate = nil
                self.delegate?.deleteAccount()
            default:
                print("")
            }
        }
    }
    
    func updateViewWithLoading() {
        loadScreen = LoadingScreen(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
        self.view.addSubview(loadScreen)
    }
    
}
