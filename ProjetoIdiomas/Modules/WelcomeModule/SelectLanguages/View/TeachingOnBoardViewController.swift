//
//  TeachingOnBoardViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 18/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class TeachingOnBoardViewController:  LearningOnBoardViewController{

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let imageName = screenHeight != 736 ? "onBoard2" : "onBoard2-iphone8"
        backgroundImage.image = UIImage(named: imageName)
        // Do any additional setup after loading the view.
    }


     @IBAction override func tappedOnButton(_ sender: Any) {
        pageDelegate?.goNextPage(fowardTo: .selectLanguageTeaching)
    }
}
