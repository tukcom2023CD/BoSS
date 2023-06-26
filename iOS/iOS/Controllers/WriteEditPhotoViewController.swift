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
    
    
    var photoArray = [ImageData]()
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
        self.delegate?.updatePhotoArray(self.photoArray)
        self.delegate?.appendDeletedPhotoArray(self.photoArray[sender.tag])
        self.photoArray.remove(at: sender.tag)
        self.collectionView.reloadData()
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        if photoArray.count == 8 {
            
            let alertController = UIAlertController(title: "이미지 업로드 제한", message: "이미지는 최대 8장까지 업로드가 가능합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 8 - self.photoArray.count
        
        
        presentImagePicker(imagePicker) { asset in
            
        } deselect: { asset in
        } cancel: { assets in
        }
        finish: { assets in
            self.convertAssetsToImages(from: assets)
        }
    }
    
    
    func convertAssetsToImages(from assets: [PHAsset]) {
        
        
        let totalImagesCount = self.photoArray.count + assets.count
        
        if totalImagesCount > 8 {
            
            
            let alertController = UIAlertController(title: "이미지 업로드 제한", message: "이미지는 최대 8장까지 업로드가 가능합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
            
        }
        if assets.count != 0 {
            var convertedImages = [ImageData]()
            for i in 0..<assets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                //option.deliveryMode = .highQualityFormat
                manager.requestImage(for: assets[i], targetSize: .zero, contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                })
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)!
                convertedImages.append(ImageData(image: newImage, isAdded: true))
            }
            self.photoArray.append(contentsOf: convertedImages)
            self.collectionView.reloadData()
            self.delegate?.updatePhotoArray(self.photoArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.photoArray.count
        return self.photoArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingEditPhotoCollectionViewCell", for: indexPath) as? WritingEditPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.deleteButton.tag = indexPath.row
        cell.photoCell.image = photoArray[indexPath.row].image
        cell.photoCell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
