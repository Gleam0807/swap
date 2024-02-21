//
//  SuggestionViewController.swift
//  swap
//
//  Created by SUNG on 1/28/24.
//

import UIKit


class SuggestionViewController: UIViewController {
    var defaultCheckList: [Bool] = [false, false, false, false]
    
    var defaultSwapList: [SwapList] = [
    SwapList(swapId: 1, title: "하루 물 1L 마시기", isCompleted: false, startDate: Date(), endDate: Date(), isAlarm: false, isDateCheck: true, alramDate: nil),
    SwapList(swapId: 2, title: "책 한 권 읽기", isCompleted: false, startDate: Date(), endDate: Date(), isAlarm: false, isDateCheck: true, alramDate: nil),
    SwapList(swapId: 3, title: "운동 30분 이상 하기", isCompleted: false, startDate: Date(), endDate: Date(), isAlarm: false, isDateCheck: true, alramDate: nil),
    SwapList(swapId: 4, title: "영단어 50개 암기하기", isCompleted: false, startDate: Date(), endDate: Date(), isAlarm: false, isDateCheck: true, alramDate: nil)]
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
    @IBAction func firstCheckboxChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        defaultCheckList[0] = sender.isSelected
    }
    @IBAction func secondCheckboxChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        defaultCheckList[1] = sender.isSelected
    }
    @IBAction func thirdCheckboxChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        defaultCheckList[2] = sender.isSelected
    }
    @IBAction func fourthCheckboxChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        defaultCheckList[3] = sender.isSelected
    }
    @IBAction func startButtonClicked(_ sender: UIButton) {
        var filterList: [SwapList] = []
        for i in 0..<defaultSwapList.count {
            if defaultCheckList[i] {
                let swap = defaultSwapList[i]
                filterList.append(swap)
            }
        }
        
        SwapList.swapLists = filterList
        
        if filterList.isEmpty {
            let alert = UIAlertController(title: "[ 안내 ]", message: "습관추천이 필요하지 않을 시 [Jump]버튼으로 Swap을 이용하실 수 있습니다", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
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
