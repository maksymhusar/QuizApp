//
//  CategoriesViewController.swift
//  QuizApp
//
//  Created by Maksym Husar on 12/25/17.
//  Copyright © 2017 Maksym Husar. All rights reserved.
//

import UIKit
import PKHUD

class CategoriesViewController: UIViewController, Alertable {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var datasource: [Category] { return DataManager.instance.categories }
    private var filteredData: [Category] = []
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        setupTableView()
        setupSearchBar()
        addNotifications()
        loadCategories()
        addClearStorageDebugButton()
    }
    
    // MARK: - Private methods
    private func addClearStorageDebugButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(resetDataPressed))
    }
    
    @objc private func resetDataPressed() {
        DataManager.instance.clearLocalStorage()
        showMessage(title: "Local Storage is cleared")
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "metal_background"))
        tableView.register(CategoryTableCell.self)
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesLoaded), name: .CategoriesLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFailLoadCategories), name: .DidFailLoadCategories, object: nil)
    }

    private func loadCategories() {
        HUD.showProgress()
        DataManager.instance.loadCategories()
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    private func getItem(by indexPath: IndexPath) -> Category {
        return isSearchActive ? filteredData[indexPath.row] : datasource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredData.count : datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryTableCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryTableCell = tableView.dequeueReusableCell(for: indexPath)
        let item = getItem(by: indexPath)
        cell.update(title: item.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getItem(by: indexPath)
        let questionsVC = QuestionsViewController(category: item)
        navigationController?.pushViewController(questionsVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension CategoriesViewController: UISearchBarDelegate {
    private func filterContent(byName name: String) {
        isSearchActive = !name.isEmpty
        filteredData = datasource.filter { $0.name.localizedCaseInsensitiveContains(name) }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(byName: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

}

// MARK: - Notifications
private extension CategoriesViewController {
    @objc func categoriesLoaded() {
        HUD.hide()
        tableView.reloadData()
    }
    
    @objc func didFailLoadCategories() {
        HUD.hide()
        showMessage(title: "Error! Loading failed, try again later!")
    }
}
