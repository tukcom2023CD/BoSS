//
//  PlacePhotosTableViewCell.swift
//  iOS
//
//  Created by 이정동 on 2023/02/07.
//

import UIKit
import GooglePlaces

class PlacePhotosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    
    var photos: [UIImage?] = []
    var photoMetadata: [GMSPlacePhotoMetadata]?
    
    private var placesClient: GMSPlacesClient!
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        placesClient = GMSPlacesClient.shared()
        
        setupCollectionView()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        setupPhotoData()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        
        let collectionCellWidth = (collectionView.frame.height - PlacePhotoCVCell.spacingWitdh * (PlacePhotoCVCell.cellRows - 1)) / PlacePhotoCVCell.cellRows
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = PlacePhotoCVCell.spacingWitdh
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = PlacePhotoCVCell.spacingWitdh
        
        // 컬렉션뷰 속성에 flowLayout 할당
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(UINib(nibName:"PlacePhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "PlacePhotoCollectionViewCell")
    }
    
    // Google Places 장소 사진 가져오기
    func setupPhotoData() {
        guard let photoMetadata = photoMetadata else { return }
        
        DispatchQueue.global().async {
            let downloadGroup = DispatchGroup()
            photoMetadata.forEach { photo in
                downloadGroup.enter()
                self.placesClient.loadPlacePhoto(photo) { image, error in
                    if let image = image {
                        self.photos.append(image)
                    }
                    downloadGroup.leave()
                }
            }
            
            downloadGroup.notify(queue: DispatchQueue.main) {
                self.collectionView.reloadData()
            }
        }
        
    }
    
}


extension PlacePhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlacePhotoCollectionViewCell", for: indexPath) as! PlacePhotoCollectionViewCell
        
        cell.photo.image = photos[indexPath.item]
        
        return cell
    }
    
}
