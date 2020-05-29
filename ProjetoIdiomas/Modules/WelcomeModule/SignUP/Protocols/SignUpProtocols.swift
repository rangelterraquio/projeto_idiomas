//
//  SignUpProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
//  var presenter: FeedInteratorToPresenter
public protocol SignUpInteratorToPresenter: class{
    
    func userAuthenticated(user: User) -> Void
    func userAuthenticationFailed(error msg: String) -> Void
    func validateTextFieldFailed(error msg: String) -> Void
    func validateTextsuccessful() -> Void

    
}

public protocol SignUpPresenterToView: class{
    func updateView(text: String) -> Void
    func showAlertError(error msg:String) -> Void
}
public protocol SignUpPresenterToInterator: class{
    
    func authenticateWithApple(with view: UIViewController)
    func signUpUser(name: String, email: String, password: String)->Void
    func authenticateWithGoogle()
    func validateTextFields(name: String?, email: String?, password: String?)
}

public protocol SignUpViewToPresenter: class {
    
    func validateTextFields(name: String?, email: String?, password: String?)
    func authenticateWithApple(with view: UIViewController)
}

public protocol SignUpRouterToPresenter{
    func didSuccessfullyLogin(user: User)
    func chooseSignInWithEmail()
    func showErrorAlert(error: String)
}
