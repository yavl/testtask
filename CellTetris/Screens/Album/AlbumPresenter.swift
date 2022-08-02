//
//  AlbumPresenter.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation

class AlbumPresenter {
    
    unowned private var view: AlbumView
    
    private(set) var imageUrls: [String]
    
    private let defaultImageUrls = [
        "https://i.imgur.com/w5rkSIj.jpg",
        "https://i.imgur.com/db7WKDn.jpeg",
        "https://i.imgur.com/sOhpQ2n.jpeg",
        "https://i.imgur.com/lrRvPhL.jpeg",
        "https://i.imgur.com/rmFxZua.jpeg",
        "https://i.imgur.com/ReVpId3.jpeg"
    ]
    
    init(view: AlbumView) {
        self.view = view
        
        imageUrls = defaultImageUrls
        view.reloadCollectionView()
    }
    
    func onRefreshControl() {
        ImageLoader.clearCache()
        self.imageUrls = self.defaultImageUrls
        self.view.reloadCollectionView()
    }
    
    func onRemoveItem(at index: Int) {
        imageUrls.remove(at: index)
    }
}
