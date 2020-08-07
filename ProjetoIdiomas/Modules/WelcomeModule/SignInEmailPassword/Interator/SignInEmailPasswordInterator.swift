//
//  SignInEmailPasswordInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

public class SignInEmailPasswordInterator: SignInEmailPasswordPresenterToInterator{
   
    
    
    var storage: StoregeAPI!
    var signUpAPI: SignUpAPI!

    var presenter: SignInEmailPasswordInteratorToPresenter? = nil
    
    init(signUpAPI: SignUpAPI, storage: StoregeAPI) {
        self.storage = storage
        self.signUpAPI = signUpAPI
    }
    
    public func resetPassword(from email: String?) {
        guard let email = email else{
            presenter?.resetPasswordFailed(error: "Email Invalid")
            return
        }
        signUpAPI.resestPassword(email: email) { [weak self] (error) in
            if let error = error{
                self?.presenter?.resetPasswordFailed(error: error.errorMessage)
            }else{
                self?.presenter?.didSuccessfullyresetPasswordSent()
            }
        }
    }
    
    public func validateUser(email: String?, password: String?) {
        guard let email = email, let password = password else{
            presenter?.userAuthenticationFailed(error: "Email or password invalid, try it again!")
            return
        }
        signUpAPI.signWithEmail(email: email, password: password) { (result) in
            switch result{
            case .failure(let errorCode):
                self.presenter?.userAuthenticationFailed(error: errorCode.errorMessage)
            case .success(_):
                self.storage.fetchUser { (user, error) in
                    if let user = user, error == nil{
                        self.presenter?.didSuccessfullyLogin(user: user)
                    }else{
                         self.presenter?.userAuthenticationFailed(error: "Something goes wrong, try it again later")
                    }
                }
            }
        }
    }
}
