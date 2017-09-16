#!/usr/bin/swift

import Cocoa


func getLyrics(artist: String, song: String) -> String {

	let artist = artist.lowercased()
	let song = song.lowercased()

	let baseURL = "https://www.azlyrics.com/lyrics/"
	
	//let temp = song + " by " + artist
	//return (temp)

	let URL = baseURL + artist + "/" + song + ".html"
	return(URL)
}

print(getLyrics(artist: "CHAINsmoKeRs", song: "ClOsEr"))
