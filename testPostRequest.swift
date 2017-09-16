#!/usr/bin/swift

func sendText(text: String) {

	var request = URLRequest(url: URL(string: "http://")!)
	request.httpMethod = "POST"
	let postString = "msg=\(text)"
	request.httpBody = postString.data(using: .utf8)
	let task = URLSession.shared.dataTask(with: request) { data, response, error in 
		guard let data = data, error == nil else {
			print("error=\(error)")
			return
		}
		
		if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
			print("Status Code: \(httpStatus.statusCode)")
			print("Response: \(response)")
		}

		let responseString = String(data: data, encoding: .utf8)
		print("responseString = \(responseString)")
	}

	task.resume()
}


