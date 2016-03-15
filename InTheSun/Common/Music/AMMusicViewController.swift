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
        
        self.setupButtonsAndTitlesState()
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
        
        if let playlist = self.playlist {
            let track = playlist.tracks[index]
            player.pause()
            player = AVPlayer(URL: track.streamURL!)
            player.play()
            currentPlayingIndex = index
            contentTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
            
            //WARNING: Set correct artist name
            var trackInfo:[String:AnyObject] = [MPMediaItemPropertyArtist:"АукцЫон", MPMediaItemPropertyTitle:track.title, MPMediaItemPropertyAlbumTitle:playlist.title, MPMediaItemPropertyPlaybackDuration:track.duration / 1000]
            
            if let artwork = self.albumArtwork.image {
                trackInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: artwork)
            }
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = trackInfo
        }
    }
    
    private func isPlaying() -> Bool {
        return (self.player.rate != 0 && self.player.error == nil)
    }
    
    func tracksCount() -> Int {
        if let playlist = self.playlist {
            return playlist.tracks.count
        }
        return 0
    }
    
    func setupButtonsAndTitlesState() {

        playButton.selected = isPlaying()
        if let playlist = self.playlist {
            songDurationLabel.hidden = false
            songTitle.hidden = false
            let track = playlist.tracks[currentPlayingIndex]
            songTitle.text = track.title
            songDurationLabel.text = AMStringUtils.durationString(track.duration)
        } else {
            songDurationLabel.hidden = true
            songTitle.hidden = true
        }
        
        let indexPath = NSIndexPath(forRow: currentPlayingIndex, inSection: 0)
        if let selectedCell = contentTableView.cellForRowAtIndexPath(indexPath) as? AMSongCell {
            if isPlaying() {
                selectedCell.setIconHighlighted(true)
            } else {
                selectedCell.setIconHighlighted(false)
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func togglePlay() {
        if (self.isPlaying()) {
            self.player.pause()
        } else {
            self.player.play()
        }
        self.setupButtonsAndTitlesState()
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let songCell = cell as? AMSongCell {
            let iconActive = isPlaying() && (currentPlayingIndex == indexPath.row)
            songCell.setIconHighlighted(iconActive)
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentPlayingIndex == indexPath.row {
            if (self.isPlaying()) {
                self.player.pause()
            } else {
                self.player.play()
            }
        } else {
            playItem(indexPath.row)
        }
        setupButtonsAndTitlesState()
    }
    
    
    //MARK: - SoundCloudDelegate Methods
    
    func didLoadAlbum(playlist: Playlist) {
        self.playlist = playlist
        self.contentTableView.reloadData()
        self.albumTitle.text = self.playlist!.title
        self.soundcloudFacade.loadAlbumImage()
        self.setupButtonsAndTitlesState()
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
