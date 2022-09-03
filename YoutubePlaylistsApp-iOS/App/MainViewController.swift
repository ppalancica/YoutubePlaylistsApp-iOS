//
//  MainViewController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/1/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var modelsController: ModelsController? {
        didSet {
            loadPlaylistCategories()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Main"
        view.backgroundColor = .red
    }
    
    func loadPlaylistCategories() {
        print("Loading...")
        modelsController?.getPlaylistCategories { categories in
            print("categories = \(categories)")
            self.finishedLoadingPlaylistCategories()
        }
    }
    
    func finishedLoadingPlaylistCategories() {
        print("Finished Loading...")
        navigateToPlaylistCategoryVC()
    }
    
    func navigateToPlaylistCategoryVC() { // playlistCategories: [PlaylistCategory]) {
        guard let nc = navigationController else {
            print("MainViewController must be embedded inside a UINavigationController")
            return
        }
        let vc = PlaylistCategoryViewController()
        vc.modelsController = modelsController
        nc.pushViewController(vc, animated: true)
    }
}
