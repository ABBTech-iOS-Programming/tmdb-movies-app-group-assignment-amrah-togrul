//
//  WatchListRequest.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

struct WatchListRequest: Encodable {
    let media_type: String
    let media_id: Int
    let watchlist: Bool
}
