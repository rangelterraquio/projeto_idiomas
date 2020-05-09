//
//  StateTextField.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 23/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

public enum StateTextField {
    
    ///Erros pssíveis
    public enum StateError: Error {
        case empty
        case textInvalid
    }
    
    case valid(String)
    case invalid(StateError,InputValidationType)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
}

public enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidCharacterFound(Character)
    case isEmpty
    case notValideFormat
}
