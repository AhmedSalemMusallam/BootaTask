//
//  AlbumPhotosViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import UIKit

class AlbumPhotosViewController: UIViewController {

    //Declare Segue variables to receive datas.
    var albumId: Int?
    var albumName: String?
    //MArk:- outlets
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var backIcon: UIButton!
    
    //Mark:- Back Icon Action
    @IBAction func backIconAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //Mark:- Setting up the search Controller
    private let searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search in images.."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGreen
        
        //Mark:- Setting the name of the album
        albumNameLabel.text = albumName ?? ""
        
        //Adding the search Control to the view
        navigationItem.searchController = searchController
    }
    

   
}
