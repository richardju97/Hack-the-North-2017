//
//  SearchVideoViewModel.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import RxSwift

struct SearchVideoViewModel {
    var track: Track?

    func getSong(query: String, success: @escaping ([Track]) ->(), failure: ((Error) -> ())?) {
        ITunesAPI.shared.getITunesSearch(with: query, success: { tracks in
            success(tracks)
        }, failure: { error in
            failure?(error)
        })
    }
}
