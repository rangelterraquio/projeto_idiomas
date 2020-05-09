//
//  SignUpInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseAuth

public class SignUpInterator{

    enum State {
        case valid
        case invalid
    }
    var textInterator: TextFieldInterator!
    var presenter: SignUpInteratorToPresenter? = nil
    
    var signUpAPI = SignUpAPI()
    
    init(textInterator: TextFieldInterator) {
        self.textInterator = textInterator
        
        
        signUpAPI.signWithAppleSuccessful = { name, email in
            print("Login com sucesso , devo peform segue aqui")
        }
        
        signUpAPI.signWithAppleFailed = { [weak self] msg in
            self?.presenter?.userAuthenticationFailed(error: msg)
        }
        
        signUpAPI.signWithGoogleSuccessful = {user in
            print("Login com sucesso , devo peform segue aqui")
        }
        
        signUpAPI.signWithGoogleFailed = { [weak self] msg in
            self?.presenter?.userAuthenticationFailed(error: msg)
        }
        
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
        
        signUpUser(name: name!, email: email!, password: password!)
        
    }
    
    
    public func signUpUser(name: String, email: String, password: String) {
        //fazer o login do usuário por firebase
        
        signUpAPI.createUserWith(email: email, password: password) { [weak self] (result) in
            switch result{
            case .failure(let error):
                self?.presenter?.userAuthenticationFailed(error: error.errorMessage)
            case .success(let user):
                let user = User(id: user.uid, name: name, photoURL: nil, score: 0, rating: 0, fluentLanguage: [String](), learningLanguage: [String](), idPosts: [String](), idCommentedPosts: [String]())
                // perform segue para as outras páginas
                print("login com sucesso")
            }
        }
        
        
    }
    public func authenticateWithApple(with view: UIViewController) {
        signUpAPI.appleSignInCalled(from: view)
        //Maria2412$ teste2
    }
    
   
    
    public func authenticateWithGoogle() {
        print("")
    }
   
    
    
}

public enum TextFieldsErrorsMsg: String {
    case nameIsEmpty        = "Name can not be empty."
    case nameIsTooLong      = "Name is too long."
    case emailInvalid       = "Email invalid."
    case emailIsEmpty       = "Email can not be empty."
    case passwordInvalid    = "Password invalid."
    case passwordIsEmpty = "Password can not be empty."
}
