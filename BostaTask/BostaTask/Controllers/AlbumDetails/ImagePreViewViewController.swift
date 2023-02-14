//
//  ImagePreViewViewController.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import UIKit
import SDWebImage

class ImagePreViewViewController: UIViewController {

    //MArk:- image url
    var imageUrlString:String?
    //MArk:- outlets
    private let scrolViewContainer : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageViewPreviewer : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var shareButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)

        button.tintColor = .white
        button.backgroundColor = .link
        button.layer.cornerRadius = 20
        

        return button
    }()
    
    
    //Mark:- share button action
    @objc func shareButtonAction() {
        // image to share
        let image = imageViewPreviewer.image
                
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.frame.size.width/2
        imageViewPreviewer.frame =
        CGRect(
            x: (scrolViewContainer.width-size)/4,
            y: 30, width: 300, height: 300)
        shareButton.frame =
        CGRect(x: 30,
               y: imageViewPreviewer.bottom+250 , width: scrolViewContainer.width-60, height: 52)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Firing the image preveiw 
        setUpScrollView()
        //setting the image from the api
        configure(imageUrl:imageUrlString ?? "")
        view.backgroundColor = .white
        scrolViewContainer.frame = view.bounds
        
        view.addSubview(scrolViewContainer)
        scrolViewContainer.addSubview(imageViewPreviewer)
        view.addSubview(shareButton)
        
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    }
    
    
    //Mark:- set up scroll view delegation
    func setUpScrollView()
    {
        scrolViewContainer.delegate = self
    }
    
    //Mark:- configure
    func configure(imageUrl:String)
    {
        guard let url = URL(string: imageUrl ) else { return }
        imageViewPreviewer.sd_setImage(with: url )
    }
    
    
}

extension ImagePreViewViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewPreviewer
    }
}
