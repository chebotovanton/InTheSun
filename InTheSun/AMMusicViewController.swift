import UIKit
import Soundcloud
import AVFoundation

class AMMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SoundCloudDelegate {

    private let kSongCellIdentifier = "songCell"
    
    var player: AVPlayer = AVPlayer()
    var playlist: Playlist?
    var currentPlayingIndex: Int = -1
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var soundcloudFacade: SoundCloudFacade!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kSongCellIdentifier)
        let footer = UIView()
        footer.frame = CGRectMake(0, 0, 10, 50.0)
        self.contentTableView.tableFooterView = footer
        self.soundcloudFacade = SoundCloudFacade()
        self.soundcloudFacade.delegate = self;
        self.soundcloudFacade.loadAlbum(41780534)
    }
    
    //MARK: - Private
    
    func playItem(index: Int) {
        let track = self.playlist!.tracks[index]
        self.player.pause()
        self.player = AVPlayer(URL: track.streamURL!)
        self.player.play()
        self.setupPlayButton()
        self.currentPlayingIndex = index
        self.songTitle.text = track.title
        self.contentTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
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
            self.playButton.setTitle("Pause", forState: .Normal)
        } else {
            self.playButton.setTitle("Play", forState: .Normal)
        }
    }

    
    //MARK: - IBActions
    
    @IBAction func play() {
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
        }
    }
    
    @IBAction func previous() {
        let newIndex = self.currentPlayingIndex - 1
        if newIndex >= 0 {
            self.playItem(newIndex)
        }
    }
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracksCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kSongCellIdentifier)
        cell?.textLabel?.text = self.songTitle(indexPath.row)
        return cell!
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
    
}
