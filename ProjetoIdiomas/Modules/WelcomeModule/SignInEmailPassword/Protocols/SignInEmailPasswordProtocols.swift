//
//  SignInEmailPasswordProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

public protocol SignInEmailPasswordInteratorToPresenter: class{
    

    func userAuthenticationFailed(error msg: String) -> Void
    func resetPasswordFailed(error msg: String) -> Void
    func didSuccessfullyLogin(user: User)
    func didSuccessfullyresetPasswordSent() -> Void

    
}

public protocol SignInEmailPasswordPresenterToView: class{
    func showError(error msg:String) -> Void
    func didSuccessfullyresetPasswordSent() -> Void
}
public protocol SignInEmailPasswordPresenterToInterator: class{
    
    func resetPassword(from email: String?)
    func validateUser(email: String?, password: String?)
}

public protocol SignInEmailPasswordViewToPresenter: class {
    
    func validateUser(email: String?, password: String?)
    func resetPassword(from email: String?)
}

public protocol SignInEmailPasswordRouterToPresenter{
    func didSuccessfullyLogin(user: User)
   // func showErrorAlert(error: String)
}
