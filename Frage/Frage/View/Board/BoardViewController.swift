//
//  BoardViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var boards: [Board] = [Board]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        let refreshControl = UIRefreshControl(frame: CGRect.zero)
//        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
//        tableView.refreshControl = refreshControl
        
        boardInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        boardInit()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as! BoardTableViewCell
        
        cell.authorNameLabel.text = boards[indexPath.row].title
        cell.authorTypeLabel.text = boards[indexPath.row].major
        cell.contentsLabel.text = boards[indexPath.row].content
        cell.dateLabel.text = boards[indexPath.row].date

        if boards[indexPath.row].category == 0 {
            cell.categoryLabel.text = "Web"
        }
        else if boards[indexPath.row].category == 1 {
            cell.categoryLabel.text = "App"
        }
        else {
            cell.categoryLabel.text = "Server"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datailVC = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateViewController(withIdentifier: "BoardDetailViewController") as! BoardDetailViewController
        datailVC.tit = boards[indexPath.row].title
        
        if boards[indexPath.row].category == 0 {
            datailVC.part = "Web"
        }
        else if boards[indexPath.row].category == 1 {
            datailVC.part = "App"
        }
        else {
            datailVC.part = "Server"
        }
        
        datailVC.part = boards[indexPath.row].major
        datailVC.time = boards[indexPath.row].date
        datailVC.name = boards[indexPath.row].name
        datailVC.content = boards[indexPath.row].content
        datailVC.img = boards[indexPath.row].frage_image
        datailVC.b_idx = String(boards[indexPath.row].board_idx)
        self.navigationController?.pushViewController(datailVC, animated: true)
        
    }
    
    //MARK : 게시판 조회 서버 통신
    func boardInit()  {
        BoardService.boardInit { (boardData) in
            
            self.boards = boardData
            self.tableView.reloadData()
            
        }
    }

}



