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
    func getVideosFor(categoryId: String, playlistId: String, completion: @escaping ([Video]) -> ())
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
        
        let categories = jsonArray.compactMap {
            PlaylistCategory(
                id: $0["playlist_category_id"] as? String ?? "",
                name: $0["name"] as? String ?? ""
            )
        }
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
                break
            }
        }
        
        guard let playlistsJson = categoryPlaylistsJson else {
            completion([])
            return
        }
        
        var playlists: [Playlist] = []
        for item in playlistsJson {
            let playlistId = item["playlist_id"] as? String ?? ""
            let playlistName = item["name"] as? String ?? ""
            playlists.append(Playlist(id: playlistId, name: playlistName))
        }
        completion(playlists)
    }
    
    func getVideosFor(categoryId: String, playlistId: String, completion: @escaping ([Video]) -> ()) {
        guard let playlistCategories = jsonDictionary["playlistCategories"] as? JsonArray else {
            completion([])
            return
        }
                
        var categoryPlaylistsJson: JsonArray?
        for category in playlistCategories {
            if (category["playlist_category_id"] as? String ?? "") == categoryId {
                categoryPlaylistsJson = category["playlists"] as? JsonArray
                break
            }
        }
        
        guard let playlistsJson = categoryPlaylistsJson else {
            completion([])
            return
        }
        
        var playlistVideosJson: JsonArray?
        for item in playlistsJson {
            if (item["playlist_id"] as? String ?? "") == playlistId {
                playlistVideosJson = item["videos"] as? JsonArray
                break
            }
        }
        
        guard let videosJson = playlistVideosJson else {
            completion([])
            return
        }
        
        var videos: [Video] = []
        for item in videosJson {
            let videoId = item["video_id"] as? String ?? ""
            let videoName = item["name"] as? String ?? ""
            let videoUrl = item["url"] as? String ?? ""
            videos.append(Video(id: videoId, name: videoName, url: videoUrl))
        }
        completion(videos)
    }
    
}
