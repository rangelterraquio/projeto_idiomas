//
//  SignUpCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit



protocol AuthenticationCoordinatorDelegate:class {
    func coordinatorDidAuthenticate(coordinator: SignUpCoordinator, user: User)
    func coordinatorDidAuthenticateWithUser(coordinator: SignUpCoordinator)
}

class SignUpCoordinator: Coordinator {
    
    fileprivate var signUpAPI: SignUpAPI!
    fileprivate var tabBarController: UITabBarController!
    
    weak var delegate: AuthenticationCoordinatorDelegate? = nil
    
    init(signUpAPI: SignUpAPI, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.signUpAPI = signUpAPI
    }
    
    func start() -> UIViewController{
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        let interator = SignUpInterator(textInterator: TextFieldInterator(), signUpAPI: signUpAPI)
        let presenter = SignUpPresenter()
        presenter.interator = interator
        presenter.view = vc
        vc.presenter = presenter
        presenter.router = self
        interator.presenter = presenter
        return vc
//        guard let topViewController = tabBarController.topViewController else {
//            return tabBarController.setViewControllers([vc], animated: false)
//        }
//        
//        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
//            self.navigationController.setViewControllers([vc], animated: false)
////            self.navigationController.pushViewController(vc, animated: true)
//        }
    }
    
}

extension SignUpCoordinator: SignUpRouterToPresenter{
    func userAlreadyUser() {
        delegate?.coordinatorDidAuthenticateWithUser(coordinator: self)
    }
    
    func showErrorAlert(error: String) {
//        let alert = UIAlertController(title: "Operation Failed", message: error, preferredStyle: .alert)
//        alert.isSpringLoaded = true
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        navigationController.show(alert, sender: nil)
    }
    
    func didSuccessfullyLogin(user: User) {
        delegate?.coordinatorDidAuthenticate(coordinator: self, user: user)
    }
    
    func chooseSignInWithEmail() {
        ///mostrar a tela de login com email
    }
    
    
}
