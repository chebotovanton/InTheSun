import UIKit
import Soundcloud

class AMSongCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var activityIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 231.0/255.0, green: 153.0/255.0, blue: 53.0/255.0, alpha: 0.15)
        self.backgroundColor = UIColor.clearColor()
        self.selectedBackgroundView = selectedView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.activityIcon.highlighted = selected
    }
    
    func setupWithTrack(track: Track) {
        self.songTitle.text = track.title
        self.songDurationLabel.text = AMStringUtils.durationString(track.duration)
    }
    
    func setIconHighlighted(highlighted: Bool) {
       activityIcon.highlighted = highlighted
    }
    
}
