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
    var myImages:[Data]! = [Data]()
    var SelectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var pickerController: UIImagePickerController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func deleteImageTapped(_ sender: UIButton) {
        
        self.myImages.remove(at: sender.tag)
        self.photoArray.remove(at: sender.tag)
        self.SelectedAssets.remove(at: sender.tag)
        self.collectionView.reloadData()
        
        
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        
        let imagePicker = ImagePickerController()
        presentImagePicker(imagePicker) { asset in
        } deselect: { asset in
        } cancel: { assets in
        }
    finish: { assets in
        for i in 0..<assets.count {
            self.SelectedAssets.append(assets[i])
        }
        self.convertAssetsToImages()
        self.collectionView.reloadData() // 갱신된 이미지 데이터를 콜렉션 뷰에 표시하기 위해 reloadData() 추가
    }
        
        
    }
    func convertAssetsToImages() -> Void {
        
        if SelectedAssets.count != 0 {
            
            self.myImages.removeAll()
            self.photoArray.removeAll()
            
            for i in 0..<SelectedAssets.count {
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                })
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                self.photoArray.append(newImage! as UIImage)
                
                self.myImages.append(data!)
                
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
        
        print("\(self.photoArray)")
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
        //cell.photoCell.layer.cornerRadius = 10
        cell.photoCell.layer.masksToBounds = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
