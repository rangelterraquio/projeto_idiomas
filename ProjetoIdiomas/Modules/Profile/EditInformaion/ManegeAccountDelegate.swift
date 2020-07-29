//
//  ManegeAccountDelegate.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation


public protocol ManegeAccountDelegate: class{
    func signOut()
    func deleteAccount()
    func reauthetication()
}
