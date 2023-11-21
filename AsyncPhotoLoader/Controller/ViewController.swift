//
//  ViewController.swift
//  AsyncPhotoLoader
//
//  Created by Natalie on 2023-11-20.
//

import UIKit

class ViewController : UIViewController {
    
    private let pageLimt = 99
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView ?? UICollectionView())
    }
    
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageLimt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        NetworkServices.shared.get(pathUrl: Keys.listApi.rawValue,
                                   parameters: ["limit" : "\(pageLimt)"],
                                   successHandler: { (data) in
            if let data = data as? [Any],
               let photoList = PhotoModel.getPhotoList(from: data) {
                cell.photoData = photoList[indexPath.row]
            }
        }) { (error) in
            print(error)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}




