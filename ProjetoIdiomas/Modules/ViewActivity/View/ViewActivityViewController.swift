//
//  ViewActivityViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 02/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ViewActivityViewController: UIViewController {
    
    var activities: [Notifaction] = [Notifaction]()
    
    var presenter: ViewActivitiesViewToPresenter? = nil
    var listener: ListenerRegistration!
    @IBOutlet weak var activitiesTableView: UITableView!
    
    @IBOutlet weak var emptyNotificationsLabel: UILabel!
    
    var fetchedAll = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Notifications"
        presenter?.updateActivities(from: Date())
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarItem.badgeValue = nil
        
        let cellXib = UINib.init(nibName: "ActivityCell", bundle: nil)
        activitiesTableView.register(cellXib, forCellReuseIdentifier: "ActivityCell")
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
      
        
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector((reloadFeed)), for: .valueChanged)
        activitiesTableView.refreshControl = refresh
        
        activitiesTableView.separatorStyle = .none
        
        
        presenter?.requestPermissionForNotification()
    }
    
    @objc func reloadFeed(){
        presenter?.updateActivities(from: Date())
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        presenter?.finishedViewNotication()
    }

    deinit {
        self.listener.remove()
    }

}



//MARK: -> TableView
extension ViewActivityViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as? ActivityCell{
        let activity = activities[indexPath.row]
        cell.populate(notif: activity)
        
            let uuid = presenter?.requestProfileImage(from: activity.authorImageURL, completion: { (result) in
            do{
                let image = try result.get()
                cell.populateWith(image: image)
            }catch{
                print(error as Any)
                cell.populateWith(image: UIImage(named: "blankProfile")!)
            }
        })
        cell.onReuse = {
            if let uuid = uuid{
                self.presenter?.cancelImageRequest(uuid: uuid)
            }
        }
            return cell
        }
        return UITableViewCell()
    }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToPost(activity: activities[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let lastVisibleIndexPath = tableView.numberOfRows(inSection: 0)
            print(lastVisibleIndexPath)
        
        ///aqui eu faço a requisição de mais posts, tenho que testar dps
        if indexPath.row == lastVisibleIndexPath-1, !activities.isEmpty {
            print("Entrou na func rangel")
            if !fetchedAll{
                presenter?.updateActivities(from: activities.last!.date)
            }
           
        }
        
    }
    
    
    
}


extension ViewActivityViewController: ViewActivitiesPresenterToView{
    func activitiesFetched(activities: [Notifaction]) {
        self.activities = activities
        self.activitiesTableView.reloadData()
        self.emptyNotificationsLabel.isHidden = !activities.isEmpty
        self.activitiesTableView.refreshControl?.endRefreshing()
    }
    
    func showAlertError(error msg: String) {
        self.emptyNotificationsLabel.isHidden = !activities.isEmpty
        self.activitiesTableView.refreshControl?.endRefreshing()
    }
    
    func fetchedAll(_ isFetched: Bool){
        self.fetchedAll = isFetched
    }
    
    
}
