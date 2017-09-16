#!/usr/bin/swift

import Cocoa
/*
func helloWorld(person: String) -> String {

	let temp = "Hello, " + person + "!"
	return (temp)
}

print(helloWorld(person: "Richard"))
*/

func getLyrics(artist: String, song: String) -> String {

	let temp = song + " by " + artist

	return (temp)

}

print(getLyrics(artist: "chainsmokers", song: "closer"))
