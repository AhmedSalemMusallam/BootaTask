//
//  AlbumPhotosViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import UIKit
import RxSwift

class AlbumPhotosViewController: UIViewController {

    
    
    //MArK:- define bag
    private var bag = DisposeBag()
    
    //Declare Segue variables to receive datas.
    var albumId: Int?
    var albumName: String?
    
    
    //Mark:- Row selected
    var rowselected: Int?
    
    //Mark:- Albums Dummy Data List
    var PhotosCollectionViewData = BehaviorSubject(value: [PhotoModel]())
   
    
    //Mark:- Setting up the search Controller
    private let searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search in images by image title.."
        controller.searchBar.searchBarStyle = .minimal
        
        
        return controller
    }()
    
    
    
    //Mark:- add the photos collection view
    
    private let photosCollectionView = UICollectionView(frame:.zero, collectionViewLayout: AlbumPhotosViewController.createLayout())
    
    //Mark:- function to create collection view layout
    static func createLayout() -> UICollectionViewCompositionalLayout{
        
        
        //triplet Item
        let tripletItem = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        //
        
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.25)
            ),
            repeatingSubitem: tripletItem,
            count: 3
        )
        
        
        
        //Sections
        let section = NSCollectionLayoutSection(group: tripletGroup)
        
        //Return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Mark:- Setting the name of the album
        self.title = albumName ?? ""
        //Adding the search Control to the view
        self.navigationItem.backBarButtonItem?.title = albumName ?? ""
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        
        //get Album Photos
        getAlbumPhotos()
        
        //Adding Collection View to the controller
        view.addSubview(photosCollectionView)
        
        photosCollectionView.register(PhotosCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
       //Mark:- photosCollectionView frame
        photosCollectionView.frame = view.bounds
               
        //Mark:- bindting Collection View
        bindPhotsCollectionView()
        
    }
    
    //Mark: bind the collection view
    func bindPhotsCollectionView()
    {
        photosCollectionView.rx.setDelegate(self).disposed(by: bag)
        PhotosCollectionViewData.bind(to: photosCollectionView.rx.items(cellIdentifier: PhotosCollectionViewCell.identifier, cellType: PhotosCollectionViewCell.self)){
            (row, item, cell) in
         
            cell.configure(with: item )
            
        }.disposed(by: bag)
        
        photosCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            
            self.rowselected = indexPath.row
            // To go to the second view.
            self.performSegue(withIdentifier: "ShowImagePreView", sender: self)
            
            
           
            
            
        }).disposed(by: bag)
        
    }
    
    //Mark:- prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let PhotosCollectionViewData = try? PhotosCollectionViewData.value() else{ return }
        guard let destinationVC = segue.destination as? ImagePreViewViewController else { return }
        
        destinationVC.imageUrlString = PhotosCollectionViewData[rowselected!].thumbnailUrl
    }
    
    
}



extension AlbumPhotosViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        
        resultsController.delegate = self
        
        
        let api: PhotosAPIProtocol = PhotosAPI()
        api.getPhotosSearch(albumId: String(albumId!) ,query: query) {[weak self](result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let Photos = response
                    
                    //MArk:- setting the labels texts from the API
                    resultsController.albumId = strongSelf.albumId
                    resultsController.PhotosCollectionViewData.on(.next(Photos ?? [PhotoModel]()))
                    
                    
                case .failure(let error):
                    print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                }
            }
            
        }
    }
    
    
    
    func searchResultsViewControllerDidTapItem(_ viewModel: PhotoModel) {
        
//        DispatchQueue.main.async { [weak self] in
//            let vc = TitlePreviewViewController()
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
}


extension AlbumPhotosViewController{
    //Mark:- get Albums Photos
    func getAlbumPhotos()
    {
        let api: PhotosAPIProtocol = PhotosAPI()
        api.getPhotos(albumId: String(self.albumId!)) {[weak  self] (result) in
            guard let stronSelf = self else { return }
            switch result {
            case .success(let response):
                let Photos = response
             
                
                //MArk:- setting the labels texts from the API
                stronSelf.PhotosCollectionViewData.on(.next(Photos ?? [PhotoModel]()))
            
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
}


//Mark:- extention for collection view delegation and datasource
extension AlbumPhotosViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rowselected = indexPath.row
    }
}



