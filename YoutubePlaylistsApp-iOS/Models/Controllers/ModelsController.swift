//
//  ModelsController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

class ModelsController {
    
    var modelsRepository: ModelsRepositoryType
    
    // To keep results cached, and avoid loading from json each time
    private var playlistCategories: [PlaylistCategory] = []
    private var playlists: [Playlist] = [] // Playlists for selected PlaylistCategory
    
    init?() {
        guard let localModelsRepository = LocalModelsRepository() else { return nil }
        
        self.modelsRepository = localModelsRepository
    }
    
    func getPlaylistCategories(completion: @escaping ([PlaylistCategory]) -> ()) {
        // self.modelsRepository.getPlaylistCategories(completion: completion)
        
        // Simulate a longer delay since data is coming from local json
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.modelsRepository.getPlaylistCategories { playlistCategories in
                self.playlistCategories = playlistCategories
                completion(playlistCategories)
            }
        }
    }
    
    func numberOfplaylistCategories() -> Int {
        return playlistCategories.count
    }
    
    func categoryAt(index: Int) -> PlaylistCategory? {
        guard index > -1 && index < playlistCategories.count else {
            print("PlaylistCategory index outside of bounds")
            return nil
        }
        return playlistCategories[index]
    }
    
    func getPlaylistsFor(categoryId: String, completion: @escaping ([Playlist]) -> ()) {
        // modelsRepository.getPlaylistsFor(categoryId: categoryId, completion: completion)
        
        // Simulate a longer delay since data is coming from local json
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.modelsRepository.getPlaylistsFor(categoryId: categoryId) { playlists in
                self.playlists = playlists
                completion(playlists)
            }
        }
    }
    
    func numberOfPlaylistsForSelectedCategory() -> Int {
        return playlists.count
    }
    
    func playlistForSelectedCategoryAt(index: Int) -> Playlist? {
        guard index > -1 && index < playlists.count else {
            print("Playlist index outside of bounds")
            return nil
        }
        return playlists[index]
    }
}
