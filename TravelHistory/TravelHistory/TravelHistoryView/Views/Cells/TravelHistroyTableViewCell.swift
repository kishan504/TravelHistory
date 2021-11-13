//
//  TravelHistroyTableViewCell.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import UIKit
class TravelHistroyTableViewCell: UITableViewCell {
    static let identifier = String(describing: TravelHistroyTableViewCell.self)
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func refreshTravelHistoryTableViewCell() {
        locationLabel.text = "mumbai"
        locationTime.text = "10:20"
    }
}
