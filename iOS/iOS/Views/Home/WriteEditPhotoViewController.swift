//
//  WriteEditPhotoViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/04/11.
//

import UIKit
import Photos
import BSImagePicker




class WriteEditPhotoViewController: UIViewController ,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
 
    
    var photoArray = [UIImage]()
    var pickerController: UIImagePickerController?

    weak var delegate: PhotoArrayProtocol?


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        print("받는쪽 사진 배열2은 \(photoArray.count)")//testing
    }
    
    
    @IBAction func deleteImageTapped(_ sender: UIButton) {
        
                self.photoArray.remove(at: sender.tag)
       
        self.collectionView.reloadData()
        self.delegate?.updatePhotoArray(self.photoArray)
        
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        
        let imagePicker = ImagePickerController()
               presentImagePicker(imagePicker) { asset in
               } deselect: { asset in
               } cancel: { assets in
               }
               finish: { assets in
                   self.convertAssetsToImages(from: assets)
               }
           }
           
    
    func convertAssetsToImages(from assets: [PHAsset]) {
        if assets.count != 0 {
            var convertedImages = [UIImage]()
            for i in 0..<assets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: assets[i], targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                })
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                convertedImages.append(newImage! as UIImage)
            }
            self.photoArray.append(contentsOf: convertedImages)
            self.collectionView.reloadData()
            self.delegate?.updatePhotoArray(self.photoArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingEditPhotoCollectionViewCell", for: indexPath) as? WritingEditPhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.deleteButton.tag = indexPath.row
        cell.photoCell.image = self.photoArray[indexPath.row]
        cell.photoCell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
