//
//  ModelsRepository.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

typealias JsonDictionary = [String: Any]
typealias JsonArray = [[String: Any]]


protocol ModelsRepositoryType {

    func getPlaylistCategories(completion: @escaping ([PlaylistCategory]) -> ())
}


class LocalModelsRepository: ModelsRepositoryType {
    
    var jsonDictionary: JsonDictionary
        
    init?() {
        guard let url = Bundle.main.url(forResource: "playlists", withExtension: "json") else {
            print("Could not find playlists.json file")
            return nil
        }
                
        do {
            let data = try Data(contentsOf: url)
            let jsonObject = try JSONSerialization.jsonObject(with: data)

            guard let jsonDictionary = jsonObject as? JsonDictionary else {
                print("Could not convert jsonObject to JsonDictionary")
                return nil
            }
            
            self.jsonDictionary = jsonDictionary
            // print("jsonDictionary = \(jsonDictionary)")
        } catch {
            print(error)
            return nil
        }
    }
    
    func getPlaylistCategories(completion: @escaping ([PlaylistCategory]) -> ()) {
        guard let jsonObject = jsonDictionary["playlistCategories"] else {
            print("Failed to find a `playlistCategories` key inside jsonDictionary")
            completion([])
            return
        }
        
        guard let jsonArray = jsonObject as? JsonArray else {
            print("Could not convert jsonObject to JsonArray")
            completion([])
            return
        }
        
        // print("jsonArray = \(jsonArray)")
        let categories = jsonArray.compactMap {
            PlaylistCategory(
                id: $0["playlist_category_id"] as? String ?? "",
                name: $0["name"] as? String ?? ""
            )
        }
        
        // print("categories = \(categories)")
        completion(categories)
    }
    
}
