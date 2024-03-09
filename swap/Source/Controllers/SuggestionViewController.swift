//
//  SuggestionViewController.swift
//  swap
//
//  Created by SUNG on 1/28/24.
//

import UIKit


final class SuggestionViewController: UIViewController {
    // MARK: Properties
    private let swapListRepository = SwapListRepository()
    private var defaultCheckList = [false, false, false, false]
    private var isCheckedList = false
    
    // MARK: Outlet
    @IBOutlet weak var suggestionTableView: UITableView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
    }
    
    //MARK: Action
    @IBAction func prevButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func jumpButtonClicked(_ sender: UIButton) {
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
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
        for (index, isChecked) in defaultCheckList.enumerated() {
            if isChecked && index >= 0 && index <= 3 {
                var title = ""
                
                switch index {
                case 0:
                    title = "하루 물 1L 마시기"
                case 1:
                    title = "책 한 권 읽기"
                case 2:
                    title = "운동 30분 이상 하기"
                case 3:
                    title = "영단어 50개 암기하기"
                default:
                    break
                }
                
                let newSwapList = SwapList(title: title, startDate: Date(), endDate: Date(), isAlarm: false, isDateCheck: true)
                swapListRepository.add(newSwapList)
                isCheckedList = true
            }
        }
        
        if !isCheckedList {
            presentAlert(title: "[ 안내 ]", message: "습관추천이 필요하지 않을 시 [Jump]버튼으로 Swap을 이용하실 수 있습니다.")
        }
        
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}

// MARK: UITableViewDataSource
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

// TODO: Table로 구현
class SuggestionTableViewCell: UITableViewCell {
    
}
