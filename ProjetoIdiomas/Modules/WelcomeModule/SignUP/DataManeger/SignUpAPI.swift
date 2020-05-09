//
//  SignUpAPI.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import AuthenticationServices
import CryptoKit
import GoogleSignIn

public enum CompletinResult<Value> {
    case success(FirebaseAuth.User)
    case failure(AuthErrorCode)
}

public class SignUpAPI: NSObject{
    
    var currentNonce: String?
    
    ///Sign with apple completions
    var signWithAppleSuccessful: (String, String) -> () = {_ , _ in}
    var signWithAppleFailed: (String) -> () = {_ in}
    
    
    ///Sign with google completions
    var signWithGoogleSuccessful: (FirebaseAuth.User) -> () = {_ in}
    var signWithGoogleFailed: (String) -> () = {_ in}
    
    public override init() {
        super.init()
        setupGoogleSignIn()
    }
    
    
    func createUserWith(email: String, password: String,completion: @escaping (CompletinResult<User>) -> Void ){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            if error != nil{
                if let error =  error as NSError?{
                    completion(.failure(AuthErrorCode(rawValue: error.code)!))
                }
            }
            if let result = authDataResult {
                completion(.success(result.user))
            }
        }
        
    }
    
    
    func userHasAValidSession() -> Bool{
        if Auth.auth().currentUser != nil {
            print("Esta logado o fdp")
            return true
        }else{
             print("ainda não está")
            return false
        }
    }
    
    func signOut() {
        
        // Check provider ID to verify that the user has signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        }
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
       
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}


//MARK: -> Sign with Apple
extension SignUpAPI:  ASAuthorizationControllerDelegate{
    
    
    
    
    func appleSignInCalled(from view: UIViewController){
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
       
        request.requestedScopes = [.fullName, .email]
        
        //cripitografico Nonce
        self.currentNonce = randomNonceString()
        request.nonce = sha256(currentNonce!)
        // pass the request to the initializer of the controller
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        // similar to delegate, this will ask the view controller
        // which window to present the ASAuthorizationController
        authController.presentationContextProvider = view as? ASAuthorizationControllerPresentationContextProviding
        
        // delegate functions will be called when user data is
        // successfully retrieved or error occured
        authController.delegate = self
        
        // show the Sign-in with Apple dialog
        authController.performRequests()
    }
    
    
    
    
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("authorization error")
            guard let error = error as? ASAuthorizationError else {
                return
            }

            switch error.code {
            case .canceled:
                // user press "cancel" during the login prompt
                print("Canceled")
            case .unknown:
                // user didn't login their Apple ID on the device
                signWithAppleFailed("This Apple ID didn't login on the device")
            case .invalidResponse:
                // invalid response received from the login
                signWithAppleFailed("Invalid Respone")
            case .notHandled:
                // authorization request not handled, maybe internet failure during login
                signWithAppleFailed("Not handled")
            case .failed:
                // authorization failed
               signWithAppleFailed("Failed")
            @unknown default:
                print("Default")
            }
        }
        
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // use the user credential / data to do stuff here ...
                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                
                
                // Retrieve the secure nonce generated during Apple sign in
                guard let nonce = self.currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }

                // Retrieve Apple identity token
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Failed to fetch identity token")
                    return
                }

                // Convert Apple identity token to string
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Failed to decode identity token")
                    return
                }

                // Initialize a Firebase credential using secure nonce and Apple identity token
                let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                  idToken: idTokenString,
                                                                  rawNonce: nonce)
                Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                    // Do something after Firebase sign in completed

                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        // Mak a request to set user's display name on Firebase
                        let changeRequest = authResult?.user.createProfileChangeRequest()
                        changeRequest?.displayName = appleIDCredential.fullName?.givenName
                        changeRequest?.commitChanges(completion: { (error) in

                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                
                                ///logion sucesseful
                                self.signWithAppleSuccessful(changeRequest?.displayName ?? "",appleIDCredential.email ?? "")
                                
                            }
                        })
                    
                    }

            }
        }
}



//MARK: -> Encrpty
extension SignUpAPI{
    ///de acordo com o firebase nós temos q encritografar quando estamos fazendo a requisicao para a apple, eles já disponibiliza esse códifo
   
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
       
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

//MARK: -> Sign in with Google
extension SignUpAPI: GIDSignInDelegate {
    
    func setupGoogleSignIn(){
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error{
            signWithGoogleFailed("Validation Failed")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error{
                let authError = error as NSError
                if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                    
                    return
                }
                self.signWithGoogleFailed(AuthErrorCode(rawValue: authError.code)?.errorMessage ?? "Validation Failed")
                return
            }
            
            self.signWithGoogleSuccessful(authResult!.user)
            
            
        }
        
    }
    
}
