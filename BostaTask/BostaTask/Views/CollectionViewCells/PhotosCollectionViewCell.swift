//
//  PhotosCollectionViewCell.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import UIKit
import SDWebImage
class PhotosCollectionViewCell: UICollectionViewCell {

    //Mark:- Image outlet
    @IBOutlet weak var imageViewCell: UIImageView!
    
    //Mark:- Cell Identifier
    static let identifier = "PhotosCollectionViewCell"
    
    
    static func nib() -> UINib
    {
        return UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with model: PhotoModel)
    {
        guard let url = URL(string: model.thumbnailUrl ?? "" ) else { return }
        print(url)
        imageViewCell.sd_setImage(with: url ,completed: nil)
        
    }
    

}
