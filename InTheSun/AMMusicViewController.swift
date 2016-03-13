import UIKit
import Soundcloud
import AVFoundation
import MediaPlayer

class AMMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SoundCloudDelegate {

    private let kSongCellIdentifier = "AMSongCell"
    
    var player: AVPlayer = AVPlayer()
    var playlist: Playlist?
    var currentPlayingIndex: Int = 0
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var soundcloudFacade: SoundCloudFacade!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPlayButton()
        self.contentTableView.registerNib(UINib(nibName: self.kSongCellIdentifier, bundle: nil), forCellReuseIdentifier: self.kSongCellIdentifier)
        
        let footer = UIView()
        footer.frame = CGRectMake(0, 0, 10, 50.0)
        self.contentTableView.tableFooterView = footer
        
        self.soundcloudFacade = SoundCloudFacade()
        self.soundcloudFacade.delegate = self;
        self.soundcloudFacade.loadAlbum(41780534)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {}
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    //MARK: - Private
    
    func playItem(index: Int) {
        let track = self.playlist!.tracks[index]
        self.player.pause()
        self.player = AVPlayer(URL: track.streamURL!)
        self.player.play()
        self.setupPlayButton()
        self.songDurationLabel.text = AMStringUtils.durationString(track.duration)
        self.currentPlayingIndex = index
        self.songTitle.text = track.title
        self.contentTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
        //WARNING: Set correct album name and artist
        var trackInfo:[String:AnyObject] = [MPMediaItemPropertyArtist:"АукцЫон", MPMediaItemPropertyTitle:track.title, MPMediaItemPropertyAlbumTitle:"На Солнце", MPMediaItemPropertyPlaybackDuration:track.duration / 1000]
        
        if let artwork = self.albumArtwork.image {
            trackInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: artwork)
        }
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = trackInfo
    }
    
    private func isPlaying() -> Bool {
        return (self.player.rate != 0 && self.player.error == nil)
    }
    
    func tracksCount() -> Int {
        if (self.playlist != nil) {
            return self.playlist!.tracks.count
        }
        return 0
    }
    
    func songTitle(songIndex: Int) -> String? {
        if (self.playlist != nil) {
            return self.playlist!.tracks[songIndex].title
        }
        return nil
    }
    
    func setupPlayButton() {
        if self.isPlaying() {
            self.playButton.selected = true
            self.songDurationLabel.hidden = false
            self.songTitle.hidden = false
        } else {
            self.playButton.selected = false
            self.songDurationLabel.hidden = true
            self.songTitle.hidden = true
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func togglePlay() {
        if (self.isPlaying()) {
            self.player.pause()
        } else {
            self.player.play()
        }
        self.setupPlayButton()
    }
    
    @IBAction func next() {
        let newIndex = self.currentPlayingIndex + 1
        if newIndex < self.tracksCount() {
            self.playItem(newIndex)
        } else {
            self.playItem(0)
        }
    }
    
    @IBAction func previous() {
        let newIndex = self.currentPlayingIndex - 1
        if newIndex >= 0 {
            self.playItem(newIndex)
        } else {
            self.playItem(self.tracksCount() - 1)
        }
    }
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracksCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kSongCellIdentifier) as! AMSongCell
        cell.setupWithTrack(self.playlist!.tracks[indexPath.row])
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.playItem(indexPath.row)
    }
    
    
    //MARK: - SoundCloudDelegate Methods
    
    func didLoadAlbum(playlist: Playlist) {
        self.playlist = playlist
        self.contentTableView.reloadData()
        self.albumTitle.text = self.playlist!.title
        self.soundcloudFacade.loadAlbumImage()
    }
    
    func albumLoadingFailed() {
        UIAlertView(title: "Error",
            message: "Could not load album data",
            delegate: nil,
            cancelButtonTitle: "OK").show()
    }
    
    func didLoadAlbumImage(image: UIImage) {
        self.albumArtwork.image = image
    }
    
    //MARK: - Remote control events
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if let subtype = event?.subtype {
            switch subtype {
                case UIEventSubtype.RemoteControlPause,
                     UIEventSubtype.RemoteControlTogglePlayPause,
                     UIEventSubtype.RemoteControlPlay:
                        self.togglePlay()
                        break
                case UIEventSubtype.RemoteControlNextTrack:
                    self.next()
                    break
                case UIEventSubtype.RemoteControlPreviousTrack:
                    self.previous()
                    break
                default:
                    break
            }
        }
    }
    
}
