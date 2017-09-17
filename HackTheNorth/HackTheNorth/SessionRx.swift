//
//  SessionRx.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import RxSwift
import APIKit

extension Session {
    func rxSendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create({ observer -> Disposable in
            let task = self.send(request, callbackQueue: nil, handler: { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create {
                task?.cancel()
            }
        })
    }

    class func rxSendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rxSendRequest(request: request)
    }
}
