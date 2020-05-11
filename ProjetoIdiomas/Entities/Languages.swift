//
//  Languages.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

public enum Languages : String{
    case portuguese = "pt"
    case english = "en"
    case spanish = "sp"
    case french = "fr"
    case chinese = "ch"
    
    var name: String {
        switch self {
        case .portuguese:
            return  "Portuguese"
        case .english:
        return  "English"
        case .spanish:
        return  "Spanish"
        case .french:
        return  "Franch"
        case .chinese:
        return  "Chinese"
        default:
            break
        }
    }
}
