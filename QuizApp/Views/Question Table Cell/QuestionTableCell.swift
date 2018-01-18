//
//  QuestionTableCell.swift
//  QuizApp
//
//  Created by Maksym Husar on 1/18/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

class QuestionTableCell: UITableViewCell, NibLoadableView, ReusableView {
    static let height: CGFloat = 50

    @IBOutlet private weak var ibLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        ibLabel.font = UIFont.font(ofSize: 18)
        ibLabel.textColor = .white
    }

    func update(title: String) {
        ibLabel.text = title
    }
}
