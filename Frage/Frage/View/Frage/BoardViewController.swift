//
//  BoardViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
}

// MARK: - View Life Cycle
extension BoardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc
    public func handleRefreshControl() {
        refreshFrage { [weak self] in
            guard let `self` = self else {
                return
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshFrage(completion: nil)
    }
}

// MARK: - Method
extension BoardViewController {
    
    private func showFrageDetail() {
        guard let controller = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() else {
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func refreshFrage(completion: (() -> Void)?) {
        FrageStore.shared.getTestFrages { [weak self] in
            guard let `self` = self else {
                return
            }
            self.tableView.reloadData()
            completion?()
        }
    }
}

// MARK: - Table View Data Source
extension BoardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FrageStore.shared.frages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let frage = FrageStore.shared.frages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as? BoardTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateViews(with: frage)
        
        return cell
    }
}

// MARK: - Table View Delegate
extension BoardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
