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
        modelsController?.getPlaylistCategories { categories in
            print("categories = \(categories)")
        }
    }
}
