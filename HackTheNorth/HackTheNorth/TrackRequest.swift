//
//  TrackRequest.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import APIKit
import ObjectMapper

protocol TrackRequest: Request {}

protocol TrackRequestError: Error {
    var localizedDescription: String { get }
}

struct FailedResponseError: TrackRequestError {
    var localizedDescription: String

    init(localizedDescription: String?) {
        self.localizedDescription = localizedDescription ?? "Error"
    }
}

extension TrackRequest {
    var baseURL: URL {
        return URL(string: "")!
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

extension TrackRequest where Response: Mappable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        let mapper = Mapper<Self.Response>()
        guard let response = mapper.map(JSONObject: object) else {
            throw FailedResponseError(localizedDescription: "Failed to obtain response.")
        }
        return response
    }
}

extension TrackRequest where Response: Any {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return object
    }
}
