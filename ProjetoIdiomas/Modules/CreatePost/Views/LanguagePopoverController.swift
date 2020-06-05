//
//  LanguagePopoverController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

public protocol LanguagePopoverDelegate: class{
    func languageDidSelect(language: Languages) -> Void
}

class LanguagePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var InstructionLabel: UILabel!
    
    var languages: [Languages] = [Languages]()
    
    weak var delegate: LanguagePopoverDelegate?
    private var contentSizeObserver : NSKeyValueObservation?

    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        let cellLanguage = UINib(nibName: "LanguageCell", bundle: nil)
        tableView.register(cellLanguage, forCellReuseIdentifier: "LanguageCell")
        tableView.allowsSelection = true
        
        
        contentSizeObserver = tableView.observe(\.contentSize) { [weak self] tableView, _ in
            let height = (self!.languages.count + 2) * Int(75) + Int((self?.doneButton.frame.height)!) + Int(self!.InstructionLabel.frame.height)
                   let width = Int(tableView.frame.width)
            self?.preferredContentSize = CGSize(width: width, height: height)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        contentSizeObserver?.invalidate()
        contentSizeObserver = nil
    }
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell{
             let language = languages[indexPath.row]
             cell.populeCell(with: language)
             return cell
         }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.languageDidSelect(language: languages[indexPath.row])
          doneButton.isEnabled = true
    }
}
