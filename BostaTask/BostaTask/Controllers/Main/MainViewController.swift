//
//  ViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    //MArK:- define bag
    private var bag = DisposeBag()
    
    //Mark:- user behavior subject
    var users = BehaviorSubject(value: UserModel())
    
    //Mark:- Row selected
    var rowselected: Int?
    
    //Mark:- Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAdressLabel: UILabel!
    
    @IBOutlet weak var albumsTableView: UITableView!
    
    
    //Mark:- Albums Dummy Data List
    var AlbumsTableViewData = BehaviorSubject(value: [AlbumModel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Mark:- Register the Table View
        albumsTableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "AlbumsTableViewCell")
        
        //fire gettin the information from the api
        getProfileBasicInformation()
        
        //fire getting the user albums
        getUserAlbums()
        
        //Mark:Binding fetched data to the view
        
        //bind user name
        self.users.asObservable()
            .map { $0.name }
          .bind(to:self.userNameLabel.rx.text)
          .disposed(by:bag)
        
        //Bind address
        self.users.asObservable()
            .map { "\($0.address?.street ?? "") ,  \($0.address?.suite ?? "")  ,  \($0.address?.city ?? "") , \($0.address?.zipcode ?? "")" }
          .bind(to:self.userAdressLabel.rx.text)
          .disposed(by:bag)
        
        //Mark:- binding album data to the view
        bindAlbumsTableView()
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? AlbumPhotosViewController else { return }
        guard let AlbumsTableViewData = try? AlbumsTableViewData.value() else{ return }
        destinationVC.albumId = AlbumsTableViewData[rowselected!].id
        destinationVC.albumName = AlbumsTableViewData[rowselected!].title
       
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .black
        navigationItem.backBarButtonItem = backItem
       
    }
    
    //Mark:- binding view functions
    func bindAlbumsTableView()
    {
        albumsTableView.rx.setDelegate(self).disposed(by: bag)
        AlbumsTableViewData.bind(to: albumsTableView.rx.items(cellIdentifier: "AlbumsTableViewCell",cellType: UITableViewCell.self)){ (row,item,cell) in
            cell.textLabel?.text = item.title
            
            
        }.disposed(by: bag)
        
        albumsTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            
            self.rowselected = indexPath.row
            // To go to the second view.
            self.performSegue(withIdentifier: "ShowAlbumImages", sender: self)
            
        }).disposed(by: bag)
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
                self?.users.on(.next(user ?? UserModel()))
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
                let Albums = response
                
                //MArk:- setting the labels texts from the API
                stronSelf.AlbumsTableViewData.on(.next(Albums ?? [AlbumModel]()))
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
}

//Mark:- uitableview datasource and delegation
extension MainViewController : UITableViewDelegate
{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
       
    }
    
}

