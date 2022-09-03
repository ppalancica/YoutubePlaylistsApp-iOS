//
//  ModelsController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

class ModelsController {
    
    var modelsRepository: ModelsRepositoryType
    
    var playlistCategories: [PlaylistCategory]?
    
    init?() {
        guard let localModelsRepository = LocalModelsRepository() else { return nil }
        
        self.modelsRepository = localModelsRepository
    }
    
    func getPlaylistCategories(completion: @escaping ([PlaylistCategory]) -> ()) {
        // self.modelsRepository.getPlaylistCategories(completion: completion)
        
        // Simulate a longer delay since data is coming from local json
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.modelsRepository.getPlaylistCategories { playlistCategories in
                self.playlistCategories = playlistCategories // Keep results cached, to avoid loading from json each time
                completion(playlistCategories)
            }
        }
    }
}
