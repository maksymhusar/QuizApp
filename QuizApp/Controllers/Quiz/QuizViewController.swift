//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/27/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, Alertable {

    @IBOutlet private weak var ibTitle: UILabel!
    @IBOutlet private weak var ibAnswersContentView: UIStackView!
    
    private let question: Question
    
    init(question: Question) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz"
        setupUI()
    }
    
    private func setupUI() {
        ibTitle.text = question.text
        setupAnswersUI()
    }
    
    private func setupAnswersUI() {
        guard !question.answers.isEmpty else { return }
        let numberOfButtonsInLine = 2
        var buttonsInLine = [UIButton]()
        for (index, answer) in question.answers.enumerated() {
            let button = UIButton()
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            button.setTitle(answer, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(answerPressed(_:)), for: .touchUpInside)
            buttonsInLine.append(button)
            if (index + 1) % numberOfButtonsInLine == 0 {
                let stackView = createAnswersHorizontalStackView(with: buttonsInLine)
                ibAnswersContentView.addArrangedSubview(stackView)
                buttonsInLine.removeAll()
            }
        }
        if !buttonsInLine.isEmpty {
            let stackView = createAnswersHorizontalStackView(with: buttonsInLine)
            ibAnswersContentView.addArrangedSubview(stackView)
        }
        
    }
    
    private func createAnswersHorizontalStackView(with buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        buttons.forEach { stackView.addArrangedSubview($0) }
        stackView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return stackView
    }

    @objc private func answerPressed(_ sender: UIButton) {
        if isCorrectAnswerPressed(sender) {
            showMessage(title: "Congratulations!",
                        message: "It's correct answer!",
                        handler: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        } else {
            showMessage(title: "Oops, that's wrong!", message: "Try again.")
        }
    }
    
    private func isCorrectAnswerPressed(_ sender: UIButton) -> Bool {
        let answerIndex = sender.tag
        return question.correctAnswerIndex == answerIndex
    }
}
