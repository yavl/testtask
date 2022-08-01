//
//  AlbumConfigurator.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation

protocol AlbumConfigurator {
    func configure(albumViewController: AlbumViewController)
}

class AlbumConfiguratorImplementation: AlbumConfigurator {
    func configure(albumViewController: AlbumViewController) {
        let presenter = AlbumPresenter(view: albumViewController)
        albumViewController.presenter = presenter
    }
}
