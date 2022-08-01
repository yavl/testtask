//
//  AlbumViewController.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation
import UIKit

fileprivate let cellIdentifier = "imageCellIdentifier"

class AlbumViewController: UIViewController {
    
    var presenter: AlbumPresenter!
    private let configurator: AlbumConfigurator
    
    private let collectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    init() {
        configurator = AlbumConfiguratorImplementation()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        configurator = AlbumConfiguratorImplementation()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(albumViewController: self)
        
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.addSubview(refreshControl)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshChanged), for: .valueChanged)
    }
    
    private func setupLayout() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc private func refreshChanged() {
        presenter.onRefreshControl()
        refreshControl.endRefreshing()
    }
}

extension AlbumViewController: AlbumView {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: presenter.imageUrls[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onRemoveItem(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: width)
    }
}
