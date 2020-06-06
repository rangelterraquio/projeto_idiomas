//
//  ProfilePresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import  UIKit

class ProfilePresenter: ProfileViewToPresenter{
   
    var router: ProfilePresenterToRouter? = nil
    
    var interator: ProfilePresenterToInterator? = nil
    func goToEditInfoView(user: User, image: UIImage?) {
        router?.goToEditInfoView(user: user, image: image)
    }
    
    
    
    
    func requestProfileImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        interator?.requestImage(from: url, completion: completion)
    }
    
    func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    
}
