//
//  Playlist.swift
//  YoutubePlaylistsApp-iOS
//
//  Created by Pavel Palancica on 9/3/22.
//

import Foundation

struct Playlist {
    let id: String
    let name: String
    
    var videos: [Video]?
}
