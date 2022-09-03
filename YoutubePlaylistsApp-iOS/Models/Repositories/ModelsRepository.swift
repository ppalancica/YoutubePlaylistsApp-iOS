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
    func getPlaylistsFor(categoryId: String, completion: @escaping ([Playlist]) -> ())
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
    
    func getPlaylistsFor(categoryId: String, completion: @escaping ([Playlist]) -> ()) {
        guard let playlistCategories = jsonDictionary["playlistCategories"] as? JsonArray else {
            completion([])
            return
        }
                
        var categoryPlaylistsJson: JsonArray?
        for category in playlistCategories {
            if (category["playlist_category_id"] as? String ?? "") == categoryId {
                categoryPlaylistsJson = category["playlists"] as? JsonArray
            }
        }
        
        guard let playlistsJson = categoryPlaylistsJson else { return }
        
        var playlists: [Playlist] = []
        for item in playlistsJson {
            let playlistId = item["playlist_id"] as? String ?? ""
            let playlistName = item["name"] as? String ?? ""
            playlists.append(Playlist(id: playlistId, name: playlistName))
        }
        completion(playlists)
    }
    
}

private extension LocalModelsRepository {
    func jsonDictionaryFor(categoryId: String) -> JsonDictionary? {
        
        return nil
    }
}
