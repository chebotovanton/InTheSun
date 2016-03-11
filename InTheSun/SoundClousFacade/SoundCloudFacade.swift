import UIKit
import Soundcloud
import AVFoundation

protocol SoundCloudDelegate {
    func didLoadAlbum(playlist: Playlist)
    func albumLoadingFailed()
    func didLoadAlbumImage(image: UIImage)
}

@objc class SoundCloudFacade: NSObject {

    var playlist: Playlist?
    var delegate: SoundCloudDelegate?
    
    class func registerUser() {
        Soundcloud.clientIdentifier = "8867dd81941c97cd17a7b2553b76a3b1"
        Soundcloud.clientSecret  = "94dcc39144fb995dab134aa073dc6679"
        Soundcloud.redirectURI = "http://google.com"
    }
        
    func loadAlbum(albumId: Int) {
        Playlist.playlist(albumId) { (result: SimpleAPIResponse<Playlist>) -> Void in
            self.playlist = result.response.result
            if (self.playlist != nil) {
                self.delegate?.didLoadAlbum(self.playlist!)
            } else {
                self.delegate?.albumLoadingFailed()
            }
        }
    }
    
    func loadAlbumImage() {
        let imageUrl = self.playlist?.artworkURL.largeURL
        self.downloadImage(imageUrl!)
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data)
                    self.delegate?.didLoadAlbumImage(image!)
                })
            }
        }
    }

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}
