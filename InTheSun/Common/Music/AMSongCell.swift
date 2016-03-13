import UIKit
import Soundcloud

class AMSongCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var activityIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.activityIcon.highlighted = selected
    }
    
    func setupWithTrack(track: Track) {
        self.songTitle.text = track.title
        self.songDurationLabel.text = AMStringUtils.durationString(track.duration)
    }
    
}
