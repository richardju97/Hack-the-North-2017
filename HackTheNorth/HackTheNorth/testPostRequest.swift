
import Foundation

enum RequestError: Error {
    case requestError
}
struct testPostRequest {
    static func sendText(text: String, success: @escaping ([String : Any]) -> (), failure: @escaping (Error) -> ()) {

        /*
         var request = URLRequest(url: URL(string: "http://httpbin.org/post")!)
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
         */
        /*
         let url = URL(string: "http://httpbin.org/post")
         let config = URLSessionConfiguration.default
         let request = NSMutableURLRequest(url: url!)
         request.httpMethod = "POST"
         let bodyData = "msg=HackTheNorth2k17"
         request.httpBody = bodyData.data(using: String.encoding.utf8)
         let session = URLSession(configuration: config)

         let task = session.dataTask(with: url! as URL, completionHandler: {(data, response,
         let json = JSON(data:data!)
         debugPrint(json)
         })
         task.resume()
         */

        //var request = URLRequest(url: URL(string: "http://httpbin.org/post")!)
        //request.httpMethod = "POST"

        //let postString = "user_id=rju"
        //request.httpBody = postString.data(using: .utf8)
        let dict = ["data":text] as [String: String]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {

            let url = NSURL(string: "http://wubalubadubdubbed.com")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if (error != nil) {
//                    print(error?.localizedDescription)
                    failure(RequestError.requestError)
                    return
                }

                if data == nil {
                    failure(RequestError.requestError)
                    return
                }

                guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] else {
                    failure(RequestError.requestError)
                    return
                }
                success(json!)
            }
            task.resume()
        } else {
            failure(RequestError.requestError)
        }


        print("Test from before task")
        //print(request.httpBody)
        /*
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
         //print("Testing print")
         //print(response)

         guard let data = data, error == nil else {
         print("error=\(error)")
         return
         }
         if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
         print("Error: \(httpStatus.statusCode)")
         print("Response: \(response)")
         }
         
         let responseString = String(data: data, encoding: .utf8)
         print("Response String = \(responseString)")
         }
         task.resume()
         */
    }
}
