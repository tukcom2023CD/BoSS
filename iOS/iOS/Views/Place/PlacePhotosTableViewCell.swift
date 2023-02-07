//
//  PlacePhotosTableViewCell.swift
//  iOS
//
//  Created by 이정동 on 2023/02/07.
//

import UIKit
import GooglePlaces

struct CVCell {
    static let spacingWitdh: CGFloat = 3
    static let cellColumns: CGFloat = 2
    private init() {}
}

class PlacePhotosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    
    var photos: [UIImage?]?
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
        
        let collectionCellWidth = (collectionView.frame.height - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        
        // 컬렉션뷰 속성에 flowLayout 할당
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(UINib(nibName:"PlacePhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "PlacePhotoCollectionViewCell")
    }
    
    func setupPhotoData() {
        print(#function)
        guard let photoMetadata = photoMetadata else { return }
        
        for metadata in photoMetadata {
            placesClient.loadPlacePhoto(metadata) { photo, error in
                if let error = error {
                    print("Error loading photo metadata: \(error.localizedDescription)")
                    return
                } else {
                    self.photos?.append(photo)
                }
            }
        }
        print(photos)

    }
    
}


extension PlacePhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlacePhotoCollectionViewCell", for: indexPath) as! PlacePhotoCollectionViewCell
        
        return cell
    }
    
}
