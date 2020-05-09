//
//  InputValidationServiceAPI.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 20/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

protocol InputValidationServiceAPI{
    func validadeTextFieldName(text: String?)throws
    func validadeTextFieldEmail(text: String?)throws
    func validadeTextFieldPassword(text: String?)throws
}

public enum InputValidationType{
    case name
    case email
    case password
}
