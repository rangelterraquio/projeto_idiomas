//
//  SignInEmailPasswordPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

public class SignInEmailPasswordPresenter: SignInEmailPasswordViewToPresenter{
   
    
    var interator: SignInEmailPasswordPresenterToInterator? = nil
    var view: SignInEmailPasswordPresenterToView? = nil
    var router: SignInEmailPasswordRouterToPresenter? = nil
    public func validateUser(email: String?, password: String?) {
        interator?.validateUser(email: email, password: password)
    }
    
    public func resetPassword(from email: String?) {
        interator?.resetPassword(from: email)
    }
       
      
    
}


extension SignInEmailPasswordPresenter: SignInEmailPasswordInteratorToPresenter{
    public func didSuccessfullyresetPasswordSent() {
        view?.didSuccessfullyresetPasswordSent()
    }
    
    public func didSuccessfullyLogin(user: User) {
        router?.didSuccessfullyLogin(user: user)
    }
    
    public func userAuthenticationFailed(error msg: String) {
        view?.showError(error: msg)
    }
    
    public func resetPasswordFailed(error msg: String) {
        view?.showError(error: msg)
    }
    
    
}
//Password2412$
