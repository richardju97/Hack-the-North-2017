#!/usr/bin/swift

import Cocoa
import Foundation

func getLyrics(artist: String, song: String) -> String {

	var artist = artist.lowercased()
	var song = song.lowercased()

	//if (artist.hasPrefix("the"))
	//	let artist = artist.index(artist.endIndex, offsetBy: -4)
		
	artist = artist.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
	song = song.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)

	let baseURL = "https://www.azlyrics.com/lyrics/"
	
	//let temp = song + " by " + artist
	//return (temp)

	let lyricURL = baseURL + artist + "/" + song + ".html"

	guard let myURL = URL(string: lyricURL)	 else {

		return("Error: \(lyricURL) doesnt seem to be a valid URL")
		
	}  

	do {
		let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
		//print("HTML : \(myHTMLString)")
		
		let BEG = "<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->"
        	let END = "<!-- MxM banner -->"
	
		let myStringArray1 : [String] = myHTMLString.components(separatedBy: END)	
		let temp1 : String = myStringArray1[0]
				
		let myStringArray2 : [String] = temp1.components(separatedBy: BEG)
		let temp2 : String = myStringArray2[1]

		let temp3 = temp2.replacingOccurrences(of: "</div>", with: "", options: NSString.CompareOptions.literal, range:nil)
		let lyrics = temp3.replacingOccurrences(of: "<br>", with: "", options: NSString.CompareOptions.literal, range:nil)

		/*
		let lyrics : [String] = temp3.components(separatedBy: "<br>")

		for var i in (0..<25) {
			print(lyrics[i])
		}
		*/

		let lyricsCut : [String] = lyrics.components(separatedBy: "\n")
		for var i in (0..<25) {
			print(lyricsCut[i])
		}

		//print(lyrics.count-25)
	
	} catch let error {
		print("Error: \(error)")
	}


	return(lyricURL)
}

getLyrics(artist: "ChAiNsMoKeRs", song: "cLoSeR")
//getLyrics(artist: "Taylor Swift", song: "Look What You Made Me Do")
//print(getLyrics(artist: "CHAINsmoKeRs", song: "ClOsEr"))
