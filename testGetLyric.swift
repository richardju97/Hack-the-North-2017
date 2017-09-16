#!/usr/bin/swift

import Cocoa
import Foundation

func getLyrics(artist: String, song: String) -> String {

	let artist = artist.lowercased()
	let song = song.lowercased()

	//if (artist.hasPrefix("the"))
	//	let artist = artist.index(artist.endIndex, offsetBy: -4)
		
	let baseURL = "https://www.azlyrics.com/lyrics/"
	
	//let temp = song + " by " + artist
	//return (temp)

	let lyricURL = baseURL + artist + "/" + song + ".html"
/*
	do{
		let unsafe: String = "<p><a href=" + URL + "onclick='stealCookies()'>Link</a></p>"
		let safe: String = try SwiftSoup.clean(unsafe, Whitelist.basic())!
		// now: <p><a href="http://example.com/" rel="nofollow">Link</a></p>
	}catch Exception.Error(let type, let message){
		print(message)
	}catch{
		print("error")
	}
*/

	guard let myURL = URL(string: lyricURL)	 else {

		return("Error: \(lyricURL) doesnt seem to be a valid URL")
		
	}  

	do {
		let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
		print("HTML : \(myHTMLString)")
	} catch let error {
		print("Error: \(error)")
	}

	return(lyricURL)
}

print(getLyrics(artist: "CHAINsmoKeRs", song: "ClOsEr"))
