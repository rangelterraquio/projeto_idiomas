//
//  SignUpPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class SignUpPresenter: SignUpViewToPresenter {
    
    
    var interator: SignUpPresenterToInterator? = nil
    var view: SignUpPresenterToView? = nil
    
 
    
   func validateTextFields(name: String?, email: String?, password: String?) {
        interator?.validateTextFields(name: name, email: email, password: password)
   }

    
    
    func authenticateWithApple(with view: UIViewController) {
        interator?.authenticateWithApple(with: view)
    }

}


extension SignUpPresenter: SignUpInteratorToPresenter{
    func validateTextsuccessful() {
        
    }
    
    
    
    func validateTextFieldFailed(error msg: String) {
        view?.updateView(text: msg)
    }
    
    
    
    func userAuthenticated() {
        print("kkfk")

        return
    }
    
    func userAuthenticationFailed(error msg: String) {
        view?.showAlertError(error: msg)
    }
    
    
}

