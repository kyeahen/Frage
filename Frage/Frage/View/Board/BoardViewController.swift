//
//  BoardViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
}

// MARK: - View Life Cycle
extension BoardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showFrageDetail()
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
}
