//
//  ViewController.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти к картинкам", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func startButtonTapped() {
        navigationController?.pushViewController(AlbumViewController(), animated: true)
    }
}

