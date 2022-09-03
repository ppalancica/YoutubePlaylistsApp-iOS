//
//  PlaylistsViewController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import UIKit

class PlaylistsViewController: UIViewController {

    var modelsController: ModelsController?
    var categoryId: String?
    lazy var playlistsTableView = createPlaylistsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupLayoutConstraints()
    }
    
    func createPlaylistsTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "PlaylistsCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }
    
    func setupUI() {
        title = "Playlists"
        view.backgroundColor = .lightGray
        view.addSubview(playlistsTableView)
    }
    
    func setupLayoutConstraints() {
        playlistsTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playlistsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playlistsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playlistsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PlaylistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelsController = modelsController else {
            return 0
        }
        return modelsController.numberOfPlaylistsForSelectedCategory()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistsCell", for: indexPath)
        guard let playlist = modelsController?.playlistForSelectedCategoryAt(index: indexPath.row) else {
            print("Could not retrieve playlist for selected category at \(indexPath.row)")
            return UITableViewCell()
        }
        cell.textLabel?.text = playlist.name
        return cell
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let playlist = modelsController?.playlistForSelectedCategoryAt(index: indexPath.row) else {
            print("Could not retrieve playlist at \(indexPath.row)")
            return
        }
        guard let categoryId = categoryId else {
            print("categoryId must have a value")
            return
        }
        loadVideosFor(categoryId: categoryId, playlistId: playlist.id)
    }
}

extension PlaylistsViewController {
    func loadVideosFor(categoryId: String, playlistId: String) {
        print("Loading...")
        modelsController?.getVideosFor(categoryId: categoryId, playlistId: playlistId) { videos in
            print("videos for playlistId \(playlistId): \(videos)")
            self.finishedLoadingVideos(categoryId: categoryId, playlistId: playlistId)
        }
    }
    
    func finishedLoadingVideos(categoryId: String, playlistId: String) {
        guard let nc = navigationController else {
            print("PlaylistsViewController must be embedded inside a UINavigationController")
            return
        }
        let vc = PlaylistVideosViewController()
        vc.modelsController = modelsController
        vc.playlistId = playlistId
        nc.pushViewController(vc, animated: true)
    }
}
