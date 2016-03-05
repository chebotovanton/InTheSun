import UIKit
import Soundcloud
import AVFoundation

@objc class SoundCloudFacade: NSObject {

    class func registerUser() {
        Soundcloud.clientIdentifier = "8867dd81941c97cd17a7b2553b76a3b1"
        Soundcloud.clientSecret  = "94dcc39144fb995dab134aa073dc6679"
        Soundcloud.redirectURI = "http://google.com"
    }
    
    class func play() {
        Track.track(169494324) { (result: SimpleAPIResponse<Track>) -> Void in
            let track = result.response.result!
            let streamUrl = result.response.result?.streamURL
            let downloadUrl = result.response.result?.downloadURL
            let permUrl = result.response.result?.permalinkURL

            do {
                let audioPlayer = try AVAudioPlayer(contentsOfURL:streamUrl!)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print("Error getting the audio file")
            }
        }
    }
    
}
