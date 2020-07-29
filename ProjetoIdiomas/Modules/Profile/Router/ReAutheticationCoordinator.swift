//
//  ReAutheticationCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 29/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

class ReAutheticationCoordinator: Coordinator, ReAutheticationRouterDelegate{
    
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var tabBarController: UITabBarController!
    var signUpAPI: SignUpAPI!
    weak var manegeAccountelegate: ManegeAccountDelegate? = nil

    init(stateController: StateController,signUpAPI: SignUpAPI, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.stateManeger = stateController
        self.signUpAPI = signUpAPI
    }
    
    
    func start() {
        let vc = ReautheticationScreenViewController(nibName: "ReautheticationScreenViewController", bundle: nil)
        
        vc.delegate = self
        vc.signUpAPI = signUpAPI
        vc.stateController = stateManeger
        signUpAPI.reAutheticationDelegate = vc
        vc.modalPresentationStyle = .overCurrentContext
        if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
            oldVc.definesPresentationContext = true
            oldVc.title = "Reauthetication"
            oldVc.pushViewController(vc, animated: true)
        }
    
    }
    
    
    func deleteAccount() {
        manegeAccountelegate?.deleteAccount()
    }
    
    
}

public protocol  ReAutheticationRouterDelegate{
    func deleteAccount()
}
