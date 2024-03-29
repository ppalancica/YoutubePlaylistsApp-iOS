//
//  MainViewController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/1/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var modelsController: ModelsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Main"
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modelsController?.removeCachedDataIfNeeded()
        loadPlaylistCategories()
    }   
}

extension MainViewController {
    func loadPlaylistCategories() {
        print("Loading...")
        modelsController?.getPlaylistCategories { categories in
            print("categories: \(categories)")
            self.finishedLoadingPlaylistCategories()
        }
    }
    
    func finishedLoadingPlaylistCategories() {
        print("Finished Loading...")
        navigateToPlaylistCategoryVC()
    }
    
    func navigateToPlaylistCategoryVC() {
        guard let nc = navigationController else {
            print("MainViewController must be embedded inside a UINavigationController")
            return
        }
        let vc = PlaylistCategoriesViewController()
        vc.modelsController = modelsController
        nc.pushViewController(vc, animated: true)
    }
}
