//
//  SectionColor.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 20/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit


  public enum SectionColor{
      case learning
      case teaching
      case unhighlited
      case commonAreas
      var color: UIColor{
          switch self {
          case .learning:
              return UIColor(red: 148/255, green: 172/255, blue: 255/255, alpha: 0.25)
          case .teaching:
              return UIColor(red: 255/255, green: 226/255, blue: 160/251, alpha: 0.25)
          case .unhighlited:
              return UIColor(red: 245/255, green: 245/255, blue: 245/251, alpha: 1.0)
          case .commonAreas:
            return UIColor(red: 122/255, green: 84/255, blue: 194/251, alpha: 0.18)
          }
      }
  }
  
