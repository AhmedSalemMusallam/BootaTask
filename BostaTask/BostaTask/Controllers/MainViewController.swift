//
//  ViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import UIKit

class MainViewController: UIViewController {

    //Mark:- Row selected
    var rowselected: Int?
    //Mark:- Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAdressLabel: UILabel!
    
    @IBOutlet weak var albumsTableView: UITableView!
    
    
    //Mark:- Albums Dummy Data List
    var AlbumsTableViewData:[AlbumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemGreen
        
        
        // Mark:- UITableView Self Delegation and DataSource
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        //Mark:- UITable Veiw registeration
        albumsTableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "AlbumsTableViewCell")
        
        //fire gettin the information from the api
        getProfileBasicInformation()
        
        //fire getting the user albums
        getUserAlbums()
        
       
        
        
    }


}

extension MainViewController
{
    //Mark:- get profile basic information
    func getProfileBasicInformation()
    {
        let api: UsersAPIProtocol = UsersAPI()
        api.getUsers {[weak  self] (result) in
            switch result {
            case .success(let response):
                let user = response
             
                //MArk:- setting the labels texts from the API
                self?.userNameLabel.text = user?.name
                self?.userAdressLabel.text = "\(user?.address?.street ?? "") ,  \(user?.address?.suite ?? "")  ,  \(user?.address?.city ?? "") , \(user?.address?.zipcode ?? "")"
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
    //Mark:- get the uset Albums
    func getUserAlbums()
    {
        let api: AlbumsAPIProtocol = AlbumsAPI()
        api.getAlbums {[weak  self] (result) in
            guard let stronSelf = self else { return }
            switch result {
            case .success(let response):
                let user = response
             
                //MArk:- setting the labels texts from the API
                stronSelf.AlbumsTableViewData = user ?? []
                stronSelf.albumsTableView.reloadData()
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
}

//Mark:- uitableview datasource and delegation
extension MainViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return AlbumsTableViewData?.count ?? 0
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsTableViewCell",for: indexPath)
        
        cell.textLabel?.text = self.AlbumsTableViewData?[indexPath.row].title ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowselected = indexPath.row
       // To go to the second view.
       self.performSegue(withIdentifier: "ShowAlbumImages", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? AlbumPhotosViewController else { return }
        destinationVC.albumId = AlbumsTableViewData?[rowselected!].id ?? 0
        destinationVC.albumName = AlbumsTableViewData?[rowselected!].title ?? ""
    }
    
}

