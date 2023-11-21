//
//  PhotoCollectionViewCell.swift
//  AsyncPhotoLoader
//
//  Created by Natalie on 2023-11-20.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    var photoData: PhotoModel? {
        didSet {
            setupCell()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.yellow
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupUI() {
        self.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        self.clipsToBounds = true
    }
    
    private func setupCell() {
        imageView.kf.cancelDownloadTask()
        
        let resolution = min(photoData?.width ?? 200, 800)
        let imageUrl = Keys.BaseUrl.rawValue + Keys.imageApi.rawValue + "/\(photoData?.id ?? "1")/\(resolution)/\(resolution)"
        
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: URL.init(string: imageUrl))
        }
    }
    
}
