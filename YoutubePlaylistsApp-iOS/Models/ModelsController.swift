//
//  ModelsController.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

class ModelsController {
    
    var modelsRepository: ModelsRepositoryType
    
    init?() {
        guard let localModelsRepository = LocalModelsRepository() else { return nil }
        
        self.modelsRepository = localModelsRepository
    }
    
    func getPlaylistCategories(completion: @escaping ([PlaylistCategory]) -> ()) {
        modelsRepository.getPlaylistCategories(completion: completion)
    }
}
