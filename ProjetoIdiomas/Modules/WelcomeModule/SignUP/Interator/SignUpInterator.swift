//
//  SignUpInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseAuth


protocol SignUpAPIDelegate {
    func didAuthoriztion() -> Void
}
public class SignUpInterator: SignUpAPIDelegate{
    
    

    enum State {
        case valid
        case invalid
    }
    var textInterator: TextFieldInterator!
    var presenter: SignUpInteratorToPresenter? = nil
    var completionSignUp:(CompletinResult<User>, String) -> () = {_, _ in}
    var signUpAPI: SignUpAPI!
    var storageAPI = StoregeAPI()
    init(textInterator: TextFieldInterator, signUpAPI: SignUpAPI!) {
        self.textInterator = textInterator
        self.signUpAPI = signUpAPI
        self.signUpAPI.interatorDelegade = self
        
        signUpAPI.signWithAppleSuccessful = {[weak self] user in
            print("Login com sucesso , devo peform segue aqui")
//            self?.presenter?.updateViewWithLoading()
            self?.storageAPI.fetchUser(completion: { (userOptional, error) in
                if error != nil{
                    self?.presenter?.userAuthenticated(user: self!.createUserFromFireBaseUser(from: user, name: nil))
                }else if let _  = userOptional{
                    self?.presenter?.userAlreadyExist()
                }
            })
//            self?.presenter?.userAuthenticated(user: self!.createUserFromFireBaseUser(from: user, name: nil))

        }
        
        signUpAPI.signWithAppleFailed = { [weak self] msg in
            self?.presenter?.userAuthenticationFailed(error: msg)
        }
        
        signUpAPI.signWithGoogleSuccessful = { [weak self] user in
            print("Login com sucesso , devo peform segue aqui")
//            self?.presenter?.updateViewWithLoading()
            self?.storageAPI.fetchUser(completion: { (userOptional, error) in
                if error != nil{
                    self?.presenter?.userAuthenticated(user: self!.createUserFromFireBaseUser(from: user, name: nil))
                    
                }else if let _  = userOptional{
                    self?.presenter?.userAlreadyExist()
                }
            })
            
//            self?.presenter?.userAuthenticated(user: self!.createUserFromFireBaseUser(from: user, name: nil))
        }
        
        signUpAPI.signWithGoogleFailed = { [weak self] msg in
            self?.presenter?.userAuthenticationFailed(error: msg)
        }
        
        completionSignUp = { result, name in
            switch result{
                case .failure(let error):
                    print("krai menor")
                    self.presenter?.userAuthenticationFailed(error: error.errorMessage)
                case .success(let user):
                    print("tomar no cu")
                    self.storageAPI.fetchUser(completion: { (userOptional, error) in
                        print("Aeeee deu bom")
                        if error == nil{
                            self.presenter?.userAuthenticated(user: self.createUserFromFireBaseUser(from: user,name: name))
                        }else if let _  = userOptional{
                            self.presenter?.userAlreadyExist()
                        }
                    })
               
               
            }
        }
        
    }
    
    func didAuthoriztion() {
        self.presenter?.updateViewWithLoading()
    }
   
    func validateTextFields(type: InputValidationType, text: String?){
        
    }

    
    
}


extension SignUpInterator: SignUpPresenterToInterator{
    
    
    public func validateTextFields(name: String?, email: String?, password: String?) {
        
        do{
            try textInterator.validadeTextFieldName(text: name)
        } catch ValidationError.isEmpty {
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.nameIsEmpty.rawValue)
            return
        }catch ValidationError.tooLong{
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.nameIsTooLong.rawValue)
            return
        }catch{
            
        }
        
        do{
            try textInterator.validadeTextFieldEmail(text: email)
        }catch ValidationError.isEmpty{
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.emailIsEmpty.rawValue)
            return
        }catch ValidationError.notValideFormat{
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.emailInvalid.rawValue)
            return
        }catch{
            
        }
        
        do{
            try textInterator.validadeTextFieldPassword(text: password)
        }catch ValidationError.isEmpty{
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.passwordIsEmpty.rawValue)
            return
        }catch ValidationError.notValideFormat{
            presenter?.validateTextFieldFailed(error: TextFieldsErrorsMsg.passwordInvalid.rawValue)
            return
        }catch{
            
        }
        
        signUpUser(name: name!, email: email!, password: password!) {(result) in
            switch result{
                case .failure(let error):
                    print("krai menor")
                    self.presenter?.userAuthenticationFailed(error: error.errorMessage)
                case .success(let user):
                    print("tomar no cu")
                    self.storageAPI.fetchUser(completion: { (userOptional, error) in
                        print("Aeeee deu bom")
                        if error != nil{
                            
                            self.presenter?.userAuthenticated(user: self.createUserFromFireBaseUser(from: user,name: name))
                        }else if let _  = userOptional{
                            self.presenter?.userAlreadyExist()
                        }
                    })
            }
        }
        
    }
    func teste(result: CompletinResult<User>, name: String){
         completionSignUp(result,name)
    }
    
    public func signUpUser(name: String, email: String, password: String,completion: @escaping (CompletinResult<User>) -> Void ) {
        //fazer o login do usuário por firebase
        
        signUpAPI.createUserWith(email: email, password: password) { (result) in
            completion(result)
        }
        
        
    }
    public func authenticateWithApple(with view: UIViewController) {
        signUpAPI.appleSignInCalled(from: view)
        //Maria2412$ teste2
    }
    
   
    
    public func authenticateWithGoogle() {
        print("")
    }
   
    func createUserFromFireBaseUser(from user: FirebaseAuth.User, name: String?) -> User{
        
        let newUser = User(id: user.uid, name:name ?? user.displayName!, photoURL: nil, score: 0, rating: 0, fluentLanguage: [String](), learningLanguage: [String](), idPosts: [String](), idCommentedPosts: [String](), fcmToken: PushNotificationManager.token ?? "dasnda", postsLiked: [String](), reportedIDs: [String]())
        return newUser
    }
    
}

public enum TextFieldsErrorsMsg: String {
    case nameIsEmpty        = "Name can not be empty."
    case nameIsTooLong      = "Name is too long."
    case emailInvalid       = "Email invalid."
    case emailIsEmpty       = "Email can not be empty."
    case passwordInvalid    = "Password invalid, It must have at minimum 8 letters with numbers,symbols and uppercase."
    case passwordIsEmpty = "Password can not be empty."
}
