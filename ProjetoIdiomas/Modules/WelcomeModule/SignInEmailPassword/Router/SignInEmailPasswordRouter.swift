//
//  SignInEmailPasswordRouter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit



public class SignInEmailPasswordCoordinator: Coordinator{
    

        fileprivate var signUpAPI: SignUpAPI!
        fileprivate var storage: StoregeAPI!
        fileprivate var tabBarController: UITabBarController!

        weak var delegate: AuthenticationCoordinatorDelegate? = nil
        
        init(signUpAPI: SignUpAPI, storage: StoregeAPI,tabBarController: UITabBarController) {
            self.storage = storage
            self.signUpAPI = signUpAPI
            self.tabBarController = tabBarController
        }
        
        func start() -> Void{
//            let vc = SignInEmailPasswordViewController(nibName: "SignInEmailPasswordViewController", bundle: nil)
//            let interator = SignInEmailPasswordInterator(signUpAPI: signUpAPI, storage: storage)
//            let presenter = SignInEmailPasswordPresenter()
//            presenter.interator = interator
//            presenter.view = vc
//            vc.presenter = presenter
//            presenter.router = self
//            interator.presenter = presenter
           let vc = PageViewController()
            vc.modalPresentationStyle = .overCurrentContext
            if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
                oldVc.definesPresentationContext = true
                oldVc.title = "Sign In"
                oldVc.pushViewController(vc, animated: true)
            }
        }
    
}


extension SignInEmailPasswordCoordinator: SignInEmailPasswordRouterToPresenter{
    
    public func didSuccessfullyLogin(user: User) {
        delegate?.coordinatorDidAuthenticateWithUser(coordinator: self)
    }
    
    
}
