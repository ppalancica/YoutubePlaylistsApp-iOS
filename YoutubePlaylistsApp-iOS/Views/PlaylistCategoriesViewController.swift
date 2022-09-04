//
//  PlaylistCategoriesViewController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import UIKit

class PlaylistCategoriesViewController: UIViewController {
    
    static let playlistCategoryCellIdentifier = "PlaylistCategoryCell"

    var modelsController: ModelsController?
    lazy var categoriesTableView = createPlaylistCategoriesTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupLayoutConstraints()
    }
    
    func createPlaylistCategoriesTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: PlaylistCategoriesViewController.playlistCategoryCellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }
    
    func setupUI() {
        title = "Playlist Categories"
        view.backgroundColor = .lightGray
        view.addSubview(categoriesTableView)
    }
    
    func setupLayoutConstraints() {
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PlaylistCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelsController = modelsController else {
            return 0
        }
        return modelsController.numberOfPlaylistCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = modelsController?.categoryAt(index: indexPath.row) else {
            print("Could not retrieve category at \(indexPath.row)")
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaylistCategoriesViewController.playlistCategoryCellIdentifier,
            for: indexPath
        )
        cell.textLabel?.text = category.name
        return cell
    }
}

extension PlaylistCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let category = modelsController?.categoryAt(index: indexPath.row) else {
            print("Could not retrieve category at \(indexPath.row)")
            return
        }
        loadPlaylistsFor(categoryId: category.id)
    }
}

extension PlaylistCategoriesViewController {
    func loadPlaylistsFor(categoryId: String) {
        print("Loading...")
        modelsController?.getPlaylistsFor(categoryId: categoryId) { playlists in
            print("playlists for categoryId \(categoryId): \(playlists)")
            self.finishedLoadingPlaylistCategories(categoryId: categoryId)
        }
    }
    
    func finishedLoadingPlaylistCategories(categoryId: String) {
        print("Finished Loading...")
        guard let nc = navigationController else {
            print("PlaylistCategoriesViewController must be embedded inside a UINavigationController")
            return
        }
        let vc = PlaylistsViewController()
        vc.modelsController = modelsController
        vc.categoryId = categoryId
        nc.pushViewController(vc, animated: true)
    }
}
