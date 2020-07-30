//
//  OnBoardViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 30/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class OnBoardViewController: LearningOnBoardViewController {
    
    
    enum OnBoardStep{
        case onBoard01
        case onBoard02
    }
    
    var onBoardStep: OnBoardStep = .onBoard01
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var labelMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }


    @IBAction override func tappedOnButton(_ sender: Any) {
        if onBoardStep == .onBoard01{
            pageDelegate?.goNextPage(fowardTo: .onBoard02)
        }else{
            pageDelegate?.goNextPage(fowardTo: .learningOnBoard)
        }
    }
    
    private func setupView(){
        if onBoardStep == .onBoard01{
            self.backgroundImage.image = UIImage(named: "OnBoardparte1")
            self.labelMsg.text = "Here we have a whole community available for you ask anything."
        }else{
            self.backgroundImage.image = UIImage(named: "OnBoardparte2")
            self.labelMsg.text = "It can be a grammatical question, a tip or even asking someone to revise your text."
        }
        
        
        
        self.backgroundImage.contentMode = .scaleAspectFit
    }
}
