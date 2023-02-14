//
//  SearchResultViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import UIKit
import RxSwift

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: PhotoModel)
}

class SearchResultViewController: UIViewController {

    //MArK:- define bag
    private var bag = DisposeBag()
    
    //Mark:- Search Controller Delegation
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    //Mark:- Row selected
    var rowselected: Int?
    
    //Mark:- Album ID
    var albumId: Int?
    
    //Mark:- Albums Dummy Data List
    var PhotosCollectionViewData = BehaviorSubject(value: [PhotoModel]())
    
    //Mark:- add the photos collection view
    public let photosCollectionView = UICollectionView(frame:.zero, collectionViewLayout: SearchResultViewController.createLayout())
    
    
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
        //MArk:- View Background
        view.backgroundColor = .white
        
        //Adding Collection View to the controller
        view.addSubview(photosCollectionView)
        
        //Mark:- register the collection view
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
            guard let PhotosCollectionViewData = try? self.PhotosCollectionViewData.value() else{ return }
            let vc = ImagePreViewViewController()
            vc.imageUrlString = PhotosCollectionViewData[indexPath.row].url
            self.present(vc, animated: true)
            
        }).disposed(by: bag)
        
    }
    
    //Mark:- prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
            guard let PhotosCollectionViewData = try? PhotosCollectionViewData.value() else{ return }
            guard let destinationVC = segue.destination as? ImagePreViewViewController else { return }
            
            destinationVC.imageUrlString = PhotosCollectionViewData[rowselected!].url
     
        
    }

}


extension SearchResultViewController{
    //Mark:- get Albums Photos
    func getAlbumPhotosSearch(query:String)
    {
        let api: PhotosAPIProtocol = PhotosAPI()
        api.getPhotosSearch(albumId:String(self.albumId!),query: query) {[weak  self] (result) in
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
extension SearchResultViewController : UICollectionViewDelegate
{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rowselected = indexPath.row

    }
    
    
    
}
