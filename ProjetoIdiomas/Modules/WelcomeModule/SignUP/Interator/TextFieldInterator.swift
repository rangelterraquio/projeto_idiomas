//
//  TextFieldInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 19/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

final class TextFieldInterator{
  
    
    
    var state: StateTextField = .invalid(.empty,.name)
    
    init() {
        //self.validationAPI = validationAPI
    }
    
    
    func validateTextField(types: [InputValidationType],from texts: [String?]) throws{
//        for (i, text) in texts.enumerated(){
//            switch types[i] {
//                case .name:
//                    try validationAPI.validadeTextFieldName(text: text)
////                    do {
////                        try validationAPI.validadeTextFieldName(text: text)
////                    } catch ValidationError.isEmpty {
////                        interator.validationFailed(type: types[i], error: ValidationError.isEmpty)
////                        break
////                    }catch ValidationError.tooLong{
////                        interator.validationFailed(type: types[i], error: ValidationError.tooLong)
////                        break
////                    }catch{
////
////                    }
//                case .email:
//                    do {
//                        try validationAPI.validadeTextFieldEmail(text: text)
//                    } catch ValidationError.isEmpty {
//
//                    } catch ValidationError.notValideFormat{
//
//                    }catch{
//
//                    }
//                case .password:
//                    do {
////                        try validationAPI.validadeTextFieldPassword(text: text)
//                    } catch ValidationError.notValideFormat {
//
//                    }catch{
//                        
//                    }
//
//                }
//
//        }
        
    }
      
    
}


//MARK: -> Input Validation
extension TextFieldInterator: InputValidationServiceAPI{
    
    func validadeTextFieldEmail(text: String?) throws {
         guard  let text = text else {return}
         if text.isEmpty{
             throw ValidationError.isEmpty
         }else if !text.contains("@"){
            throw ValidationError.notValideFormat
        }
    }
     
     func validadeTextFieldPassword(text: String?) throws {
        guard  let password = text else {return}
        if password.isEmpty{
            throw ValidationError.isEmpty
        }
        
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password){
            throw ValidationError.notValideFormat
        }
     }
     
     func validadeTextFieldName(text: String?) throws{
         if let name = text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) , !(name.count > 0) {
             throw ValidationError.isEmpty
        }
     }
}


//MARK: -> Password regex explanation
/*
 ^                         Start anchor
 (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
 (?=.*[!@#$&*])            Ensure string has one special case letter.
 (?=.*[0-9].*[0-9])        Ensure string has two digits.
 (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
 .{8}                      Ensure string is of length 8.
 $                         End anchor.
 */
