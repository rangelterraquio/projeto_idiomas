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
}

class SignUpCoordinator: Coordinator {
    
    fileprivate var signUpAPI: SignUpAPI!
    fileprivate var navigationController: UINavigationController!
    
    weak var delegate: AuthenticationCoordinatorDelegate? = nil
    
    init(signUpAPI: SignUpAPI, navitagtion: UINavigationController) {
        self.navigationController = navitagtion
        self.signUpAPI = signUpAPI
    }
    
    func start(){
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        let interator = SignUpInterator(textInterator: TextFieldInterator(), signUpAPI: signUpAPI)
        let presenter = SignUpPresenter()
        presenter.interator = interator
        presenter.view = vc
        vc.presenter = presenter
        presenter.router = self
        interator.presenter = presenter
        
        guard let topViewController = navigationController.topViewController else {
            return navigationController.setViewControllers([vc], animated: false)
        }
        
        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
            self.navigationController.setViewControllers([vc], animated: false)
//            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
}

extension SignUpCoordinator: SignUpRouterToPresenter{
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
