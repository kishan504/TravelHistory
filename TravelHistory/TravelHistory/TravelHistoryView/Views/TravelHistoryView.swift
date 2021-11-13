//
//  TravelHistoryView.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import UIKit
class TravelHistoryView: UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    static let identifier = String(describing: TravelHistoryView.self)
    let locationList: [String] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(TravelHistoryView.identifier, owner: self, options: nil)
        setupContainerView()
    }
    private func setupContainerView() {
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    func setupTravelHistoryView() {
        setupTableView()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: TravelHistroyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TravelHistroyTableViewCell.identifier)
    }
}
