//
//  BoardTableViewCell.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class BoardTableViewCell: UITableViewCell {

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorTypeLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateViews(with frage: Frage) {
        authorNameLabel.text = frage.author.name
        authorTypeLabel.text = frage.author.authorType
        contentsLabel.text = frage.contents
    }
}
