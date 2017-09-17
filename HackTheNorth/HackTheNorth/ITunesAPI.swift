//
//  ITunesAPI.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/17/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import iTunesSearchAPI
import RxSwift

enum APIError: Error {
    case jsonError
}

struct ITunesAPI {
    static var shared: ITunesAPI = ITunesAPI()

    func getITunesSearch(with query: String, success: @escaping ([Track]) -> (), failure: @escaping (Error) -> ()) {
        let itunes = iTunes(session: URLSession.shared, debug: false)

        itunes.search(for: query) { response in
            if let err = response.error {
                failure(err)
                return
            }
            if let val = response.value as? [String : Any] {
                if let results = val["results"] as? [[String : Any]] {
                    var tracks: [Track] = []
                    for result in results {
                        var name: String = ""
                        if let resultName = result["trackName"] as? String {
                            name = resultName
                        } else {
                            continue
                        }

                        var artist: String = ""
                        if let artistName = result["artistName"] as? String {
                            artist = artistName
                        } else {
                            continue
                        }

                        var image: String?
                        if let imageURL = result["artworkUrl100"] as? String {
                            image = imageURL
                        }

                        tracks.append(Track(name: name, artist: artist, trackImage: image))
                    }
                    success(tracks)
                } else {
                    failure(APIError.jsonError)
                }
            } else {
                failure(APIError.jsonError)
            }
        }?.resume()
    }
}
