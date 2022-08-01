//
//  ImageCollectionViewCell.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.isHidden = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configure(with url: String) {
        self.loader.isHidden = false
        self.loader.startAnimating()
        ImageLoader.loadImage(from: url) { image in
            self.imageView.image = image
            self.loader.stopAnimating()
            self.loader.isHidden = true
        }
    }
    
    private func setupViews() {
        layer.cornerRadius = 8
        contentView.backgroundColor = .lightGray
        contentView.addSubview(imageView)
        contentView.addSubview(loader)
    }
    
    private func setupLayout() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        loader.center = contentView.center
    }
}
