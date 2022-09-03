//
//  PlaylistCategory.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

struct PlaylistCategory {
    let id: String
    let name: String
    
    var playlists: [Playlist]?
}
