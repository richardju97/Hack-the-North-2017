
//import Cocoa
import Foundation

struct testGetLyric {
    static func getLyrics(artist: String, song: String, desiredLines: Int) throws -> String {

        var artist = artist.lowercased()
        var song = song.lowercased()

        artist = artist.replacingOccurrences(of: "the ", with: "", options:NSString.CompareOptions.literal, range:nil)
        
        artist = artist.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
        artist = artist.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
        song = song.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)

        song = song.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range:nil)
        song = song.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
        song = song.replacingOccurrences(of: "'", with: "", options: NSString.CompareOptions.literal, range:nil)

        let baseURL = "https://www.azlyrics.com/lyrics/"
        
        let lyricURL = baseURL + artist + "/" + song + ".html"

        guard let myURL = URL(string: lyricURL)	 else {
            return("Error: \(lyricURL) doesnt seem to be a valid URL")
        }  

        var lyricsString = ""
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

            let lyricsCut : [String] = lyrics.components(separatedBy: "\n")
            for var i in (0..<desiredLines) {
                lyricsString += lyricsCut[i]
            }
            print(lyricsString)
        
        } catch let error {
            throw error
//            print("Error: \(error)")
        }

        return(lyricsString)
    }

    //getLyrics(artist: "tHe ChAiNsMoKeRs", song: "cLoSeR", desiredLines: 23)
    //getLyrics(artist: "Taylor Swift", song: "Look What You Made Me Do")

    //getLyrics(artist: "Britney Spears", song: "Boys (Remix)", desiredLines: 20)
    //getLyrics(artist: "DJ Khaled", song: "I'm the one", desiredLines: 20)

    //print(getLyrics(artist: "CHAINsmoKeRs", song: "ClOsEr"))
}
