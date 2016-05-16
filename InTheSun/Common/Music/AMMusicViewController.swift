import UIKit
import Soundcloud
import AVFoundation
import MediaPlayer

class AMMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SoundCloudDelegate, AMMusicFooterViewDelegate {

    private let kSongCellIdentifier = "AMSongCell"
    private let itunesAlbumUrl = "https://geo.itunes.apple.com/album/id1108068285?mt=1&app=itunes"
    private let appUrl = "https://itunes.apple.com/us/app/na-solnce-aukcyon/id1111135609?ls=1&mt=8"
    var player: AVPlayer = AVPlayer()
    var playlist: Playlist?
    var currentPlayingIndex: Int = -1
    var albumImage: UIImage?
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var errorTitleConstraint: NSLayoutConstraint?
    
    var soundcloudFacade: SoundCloudFacade!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(itemDidFinishPLaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        if is_iPhone4() {
            if let constraint = errorTitleConstraint {
                constraint.constant = 20.0
            }
        }
                
        self.setupButtonsAndTitlesState()
        self.contentTableView.registerNib(UINib(nibName: self.kSongCellIdentifier, bundle: nil), forCellReuseIdentifier: self.kSongCellIdentifier)
        
        let footer = NSBundle.mainBundle().loadNibNamed("AMMusicFooterView", owner: nil, options: nil).first as! AMMusicFooterView
        footer.delegate = self
        footer.autoresizingMask = .None;
        self.contentTableView.tableFooterView = footer;
        
        self.contentTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
        
        self.soundcloudFacade = SoundCloudFacade()
        self.soundcloudFacade.delegate = self;
        loadAlbum()
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
    
    
    //MARK: - Public
    
    func stopMusicPlayer() {
        player.pause()
        self.setupButtonsAndTitlesState()
    }
    
    func playInitialSong() {
        playItem(6)
        let time = CMTimeMakeWithSeconds(29.0, 1)
        player.seekToTime(time)
        setupButtonsAndTitlesState()
    }
    
    func isPlaying() -> Bool {
        return (self.player.rate != 0 && self.player.error == nil)
    }
    
    //MARK: - Private
    
    private func playItem(index: Int) {
        
        if let playlist = self.playlist {
            let track = playlist.tracks[index]
            player.pause()
            player = AVPlayer(URL: track.streamURL!)
            player.play()
            currentPlayingIndex = index
            contentTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
            
            var trackInfo:[String:AnyObject] = [MPMediaItemPropertyArtist:"АукцЫон", MPMediaItemPropertyTitle:track.title, MPMediaItemPropertyAlbumTitle:playlist.title, MPMediaItemPropertyPlaybackDuration:track.duration / 1000]
            
            if let albumImage = self.albumImage {
                trackInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: albumImage)
            }
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = trackInfo
        }
    }
    
    func tracksCount() -> Int {
        if let playlist = self.playlist {
            return playlist.tracks.count
        }
        return 0
    }
    
    func setupButtonsAndTitlesState() {

        if currentPlayingIndex < 0 {
            songTitle.hidden = true
            
            return
        }
        
        playButton.selected = isPlaying()
        if let playlist = self.playlist {
            songTitle.hidden = false
            let track = playlist.tracks[currentPlayingIndex]
            songTitle.text = track.title
        } else {
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
    
    func switchToPlayMode() {
        errorView.hidden = true
        loadingView.hidden = true
        contentTableView.hidden = false
        headerView.hidden = false
    }
    
    func switchToLoadingMode() {
        errorView.hidden = true
        loadingView.hidden = false
        contentTableView.hidden = true
        headerView.hidden = true
    }
    
    func switchToErrorMode() {
        errorView.hidden = false
        loadingView.hidden = true
        contentTableView.hidden = true
        headerView.hidden = true
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
    
    @IBAction func buyAlbum() {
        let url = NSURL(string: itunesAlbumUrl)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func loadAlbum() {
        switchToLoadingMode()
        soundcloudFacade.loadAlbum(219884633)
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
        self.switchToPlayMode()
        self.playlist = playlist
        self.contentTableView.reloadData()
        self.albumTitle.text = self.playlist!.title
        self.soundcloudFacade.loadAlbumImage()
        self.setupButtonsAndTitlesState()
    }
    
    func albumLoadingFailed() {
        self.switchToErrorMode()
    }
    
    func didLoadAlbumImage(image: UIImage) {
        albumImage = image
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
    
    //MARK: - AMMusicFooterViewDelegate
    
    func share(sender: UIButton!) {
        let url = NSURL(string: appUrl)
        let image = UIImage(named: "musicAlbumIcon")
        let shareController = UIActivityViewController(activityItems: [image!, LS("LOC_SHARE_TITLE"), url!], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = sender
        self.presentViewController(shareController, animated: true, completion:nil)
    }
    
    //MARK: - Playback notifications
    
    func itemDidFinishPLaying() {
        next()
    }
    
}
