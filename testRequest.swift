#!/usr/bin/swift

import Foundation
import Alamofire

func testPost() {

	let temp: [String : Any] = [
		"date":916,
		"event":"Hack the North"
	]

	//let jsonObject = JSONSerialization.isValidJSONObject(temp)

	Alamofire.request("24.240.32.197:8000", method: .post, parameters: temp, encoding: URLEncoding.httpBody)

	/*
	let url = NSURL(string: "24.240.32.197:8000")
	let request = NSMutableURLRequest(url: url as URL)
	request.httpMethod = "POST"

	request.httpBody = jsonData
	*/
	//print(jsonObject)
}

testPost()
