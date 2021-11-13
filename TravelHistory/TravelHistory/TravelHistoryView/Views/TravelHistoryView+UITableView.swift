//
//  TravelHistoryView+UITableView.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import UIKit
extension TravelHistoryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TravelHistoryTableViewCell.identifier, for: indexPath)
        guard let travelHistoryTableViewCell = cell as? TravelHistoryTableViewCell else { return cell }
        travelHistoryTableViewCell.refreshTravelHistoryTableViewCell()
        return travelHistoryTableViewCell
    }
}
