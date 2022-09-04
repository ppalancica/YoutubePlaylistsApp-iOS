//
//  PlaylistVideosViewController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/4/22.
//

import UIKit

class PlaylistVideosViewController: UIViewController {

    static let videoCellIdentifier = "VideoCell"
    
    var modelsController: ModelsController?
    lazy var videosTableView = createVideosTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupLayoutConstraints()
    }
    
    func createVideosTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: PlaylistVideosViewController.videoCellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }
    
    func setupUI() {
        title = "Videos"
        view.backgroundColor = .lightGray
        view.addSubview(videosTableView)
    }
    
    func setupLayoutConstraints() {
        videosTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            videosTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videosTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videosTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            videosTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PlaylistVideosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelsController = modelsController else {
            return 0
        }
        return modelsController.numberOfVideosForSelectedPlaylist()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaylistVideosViewController.videoCellIdentifier,
            for: indexPath
        )
        guard let video = modelsController?.videoForSelectedPlaylistAt(index: indexPath.row) else {
            print("Could not retrieve vidoe for selected playlist at \(indexPath.row)")
            return UITableViewCell()
        }
        cell.textLabel?.text = video.name
        return cell
    }
}

extension PlaylistVideosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
