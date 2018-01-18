//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/25/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import UIKit
import PKHUD

class QuestionsViewController: UITableViewController, Alertable {
    private let category: Category
    
    private var datasource: [Question] = [] {
        didSet { tableView.reloadData() }
    }
    
    init(category: Category) {
        self.category = category
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        setupDatasource()
        addNotifications()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(QuestionTableCell.self)
        tableView.estimatedRowHeight = QuestionTableCell.height
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "dark_background"))
    }

    private func setupDatasource() {
        if let questins = DataManager.instance.questions(for: category) {
            datasource = questins
        } else {
            HUD.showProgress()
            DataManager.instance.loadQuestions(for: category)
        }
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: .QuestionsLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFailLoadQuestions), name: .DidFailLoadQuestions, object: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionTableCell = tableView.dequeueReusableCell(for: indexPath)
        let item = datasource[indexPath.row]
        cell.update(title: item.text)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        let quizVC = QuizViewController(question: item)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

// MARK: - Notifications
private extension QuestionsViewController {
    @objc func questionsLoaded() {
        HUD.hide()
        setupDatasource()
    }
    
    @objc func didFailLoadQuestions() {
        HUD.hide()
        showMessage(title: "Error! Loading failed, try again later!")
    }
}
