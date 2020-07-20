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
    case russian = "ru"
    case dutch = "nt"
    case japanese = "jp"
    case italian = "it"
    case german = "gm"
    case portuguesePT = "ptPT"
    case korean = "ko"
    case danish = "dn"
    
    var name: String {
        switch self {
        case .portuguese:
            return  "Portuguse"
        case .english:
        return  "English"
        case .spanish:
        return  "Spanish"
        case .french:
        return  "Franch"
        case .chinese:
        return  "Chinese"
        case .russian:
        return "Russian"
        case .dutch:
        return "Dutch"
        case .japanese:
        return "Japanese"
        case .italian:
        return "Italian"
        case .german:
        return "German"
        case .portuguesePT:
        return "Portuguse PT"
        case .korean:
        return "Korean"
        case .danish:
        return "Danish"
        }
    }
    
     static let languages: [Languages] = [.english,.french,.portuguese,.portuguesePT,.spanish,.chinese,.korean,.dutch,.german,.italian,.japanese,.russian,.danish]
}

