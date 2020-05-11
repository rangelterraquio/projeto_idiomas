//
//  FeedViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

public enum SectionSelected{
    case teachingSection
    case learningSection
}
class FeedViewController: UIViewController {


    var presenter: FeedViewToPresenter? = nil
    
    var posts: [Post] = [Post]()
    
    var section: SectionSelected = .teachingSection
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
        ///setup tableView
        let cellXib = UINib.init(nibName: "FeedCell", bundle: nil)
        let filterCellXib = UINib.init(nibName: "FilterCell", bundle: nil)
        feedTableView.register(filterCellXib, forCellReuseIdentifier: "filterCell")
        feedTableView.register(cellXib, forCellReuseIdentifier: "feedCell")
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        
        presenter?.updateFeed(in: [.english], from: Date())
        
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(self.retriveData), for: .valueChanged)
//        myTableView.refreshControl = refresh
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector((reloadFeed)), for: .valueChanged)
        feedTableView.refreshControl = refresh
    }
    
    @objc func reloadFeed(){
        posts.removeAll()
        if section == .teachingSection{
            presenter?.updateFeed(in: [.english], from: Date())
        }else{
            presenter?.updateFeed(in: [.french], from: Date())
        }
    }

    @IBAction func reloadTB(_ sender: Any) {
        print(self.posts)
                presenter?.updateFeed(in: [.english], from: Date())

    }
    
}


extension FeedViewController: FeedPresenterToView{
    func showPosts(posts: [Post]) {
        self.feedTableView.refreshControl?.endRefreshing()
        self.posts.append(contentsOf: posts)
        self.feedTableView.reloadData()
    }
    
    func showError() {
        print("errooou")
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterCell{
                cell.teachingSelect = {
                    self.section = .teachingSection
                    self.posts.removeAll()
                    self.presenter?.updateFeed(in: [.english], from: Date())
                }
                cell.learningSelect = {
                    self.section = .learningSection
                    self.posts.removeAll()
                    self.presenter?.updateFeed(in: [.french], from: Date())
                }
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell{
            let post = posts[indexPath.row-1] ///subtraio 1 por causa da celula statica
            print(post.publicationDate)
            cell.populate(post: post)
            if let url = post.author.photoURL{
                let uuid = presenter?.requestProfileImage(from: url, completion: { (result) in
                    do{
                        let image = try result.get()
                        cell.populateImage(image: image)
                    }catch{
                        cell.populateImage(image: UIImage(named: "blankProfile")!)
                        print(error as Any)
                    }
                })
                cell.onReuse = {
                    if let uuid = uuid{
                        self.presenter?.cancelImageRequest(uuid: uuid)
                    }
                }
            }
            
            cell.upvoted = { self.presenter?.updateVotes(from: "upvote", inPost: post)}
            cell.downVoted = {self.presenter?.updateVotes(from: "downvote", inPost: post)}
            return cell
        }
        
        fatalError("deu ruim com a cell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44
        }else{
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let lastVisibleIndexPath = tableView.numberOfRows(inSection: 0)
            print(lastVisibleIndexPath)
        
        ///aqui eu faço a requisição de mais posts, tenho que testar dps
        if indexPath.row == lastVisibleIndexPath-1, !posts.isEmpty {
            presenter?.updateFeed(in: [.english], from: posts.last!.publicationDate)
        }
        
    }
    
    
}