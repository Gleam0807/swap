//
//  SuggestionViewController.swift
//  swap
//
//  Created by SUNG on 1/28/24.
//

import UIKit

class SuggestionViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var SuggestionTableView: UITableView!
    
    override func viewDidLoad() {
        SuggestionTableView.dataSource = self
        SuggestionTableView.delegate = self
    }
    
    //MARK: Action
    @IBAction func prevButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func jumpButtonClicked(_ sender: UIButton) {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }
    }
}

extension SuggestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as? SuggestionTableViewCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        return cell
    }
    
    
}

extension SuggestionViewController: UITableViewDelegate {
    
}

class SuggestionTableViewCell: UITableViewCell {
    
}
