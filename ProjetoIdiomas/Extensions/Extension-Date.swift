//
//  Extension-Date.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 20/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation


extension Date{
    func convertToString() -> String {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
     let newDate: String = dateFormatter.string(from: self)
     return newDate
    }
}
