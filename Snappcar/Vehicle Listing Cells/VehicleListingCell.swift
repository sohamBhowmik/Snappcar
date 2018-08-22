//
//  VehicleListingCell.swift
//  Snappcar
//
//  Created by Soham Bhowmik on 18/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import UIKit
import Alamofire


protocol VehicleListingCarImageDatasource: class {
    func vehicleListingCell(_ cell: VehicleListingCell, numberOfImagesOfVehicleAtIndex index: Int) -> Int
    func vehicleListingCell(_ cell: VehicleListingCell, imageUrlOfCarAtIndex index: Int, forIndexPath indexPath:IndexPath)->String?
}


class VehicleListingCell: UITableViewCell {

    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var carImageCollectionView: UICollectionView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var pricePerDay: UILabel!
    @IBOutlet weak var freeKilometers: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var totalNumberOfRatings: UILabel!
    @IBOutlet weak var carBodyType: UILabel!
    @IBOutlet weak var carInfoHolderView: UIView!
    
    @IBOutlet weak var firstStarImgView: UIImageView!
    @IBOutlet weak var secondStarImgView: UIImageView!
    @IBOutlet weak var thirdStarImgView: UIImageView!
    @IBOutlet weak var fourthStarImgView: UIImageView!
    @IBOutlet weak var fifthStarImgView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    let kVehicleCellCollectionViewReuseId = "VehicleCellCollectionViewReuseId"
    let kFirstStarImageViewTag = 100
    
    weak var datasource: VehicleListingCarImageDatasource? = nil
    
    var indexPath: IndexPath? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    private func setupUI()
    {
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.layer.borderColor = UIColor.white.cgColor
        ownerImageView.layer.borderWidth = 2.0
        ownerImageView.layer.masksToBounds = true
        
        carImageCollectionView.register(UINib.init(nibName: "VehicleListingCarImageCell", bundle: nil), forCellWithReuseIdentifier: kVehicleCellCollectionViewReuseId)
        
        self.selectionStyle = .none
    }
    
  func populateStarView(withRating rating:Int){

        for i in kFirstStarImageViewTag..<(kFirstStarImageViewTag+5)
        {
            if let starImageView = self.viewWithTag(i) as? UIImageView{
                starImageView.image = UIImage(named: "unselectedStar")
            }
        }
    
        for i in kFirstStarImageViewTag..<(kFirstStarImageViewTag+rating)
        {
            if let starImageView = self.viewWithTag(i) as? UIImageView{
                starImageView.image = UIImage(named: "selectedStar")
            }
        }
    }
}

extension VehicleListingCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    //CollectionView DataSource and Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var numberOfImages = 1
        if (datasource == nil || self.indexPath == nil)
        {
            return numberOfImages
        }
        
        numberOfImages =  datasource!.vehicleListingCell(self, numberOfImagesOfVehicleAtIndex: self.indexPath!.row)
        numberOfImages = numberOfImages == 0 ? 1 : numberOfImages
        return numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let carImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: kVehicleCellCollectionViewReuseId, for: indexPath) as? VehicleListingCarImageCell
        {
            let numberOfImages =  datasource!.vehicleListingCell(self, numberOfImagesOfVehicleAtIndex: self.indexPath!.row)
            if numberOfImages <= 1{
                pageControl.numberOfPages = 0
            }else{
                pageControl.numberOfPages = numberOfImages
            }
            if let imageUrlString = datasource!.vehicleListingCell(self, imageUrlOfCarAtIndex: indexPath.row, forIndexPath: self.indexPath!)
            {
                if let url = URL(string: imageUrlString)
                {
                    DataRequest.addAcceptableImageContentTypes(["image/jpg"])
                    carImageCell.carImageView.af_setImage(withURL: url)
                }
                else{
                    carImageCell.carImageView.image = UIImage(named: "car_default")
                }
            }
            else{
                carImageCell.carImageView.image = UIImage(named: "car_default")
            }
            return carImageCell
        }
        else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: kVehicleCellCollectionViewReuseId, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = carImageCollectionView.indexPathForItem(at: center) {
            pageControl.currentPage = ip.row
        }
    }
}
