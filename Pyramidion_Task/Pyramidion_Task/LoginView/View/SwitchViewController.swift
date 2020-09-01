//
//  SwitchViewController.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private var switchViewModel = SwitchViewModel()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: Methods
    @objc func headerSwitchTapped(_ sender: UISwitch) {
        switchViewModel.headerState[sender.tag] = sender.isOn
        for i in 0..<tableView.numberOfRows(inSection: sender.tag) {
            if switchViewModel.switchStates[sender.tag] == nil {
                switchViewModel.switchStates[sender.tag] = [Int : Bool]()
            }
            switchViewModel.switchStates[sender.tag]![i] = sender.isOn
        }
        tableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
        nextViewController.initializeData(delegate: self)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
//MARK: table view deleagtes
extension SwitchViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 35))
        let headerSwitch = UISwitch(frame: CGRect(x: CGFloat(self.view.center.x) + 110 , y: 20, width: 60, height: 30))
        headerSwitch.tag = section
        if switchViewModel.headerState[section] == nil {
            switchViewModel.headerState[section] = true
            headerSwitch.isOn = true
        }
        if switchViewModel.checkAllSwitchStateEnabledOrNot(section: section, noOfCell: tableView.numberOfRows(inSection: section)) == true {
            headerSwitch.isOn = true
        } else if switchViewModel.checkAllSwitchStateEnabledOrNot(section: section, noOfCell: tableView.numberOfRows(inSection: section)) == false {
            headerSwitch.isOn = false
        } else if switchViewModel.headerState[section]! {
            headerSwitch.isOn = true
        } else {
            headerSwitch.isOn = false
        }
        headerSwitch.addTarget(self, action: #selector(headerSwitchTapped(_:)), for: .valueChanged)
        headerView.addSubview(headerSwitch)
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 15, width: tableView.frame.size.width - 10, height: 25))
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont.systemFont(ofSize: 14.0)
        headerLabel.text = "Header \(section)"
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.blue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchViewModel.selectedSectionFromAnotherVC.keys.contains(0) && section == 0 {
            return 4 + switchViewModel.selectedSectionFromAnotherVC[section]!
        } else if switchViewModel.selectedSectionFromAnotherVC.keys.contains(1) && section == 1 {
            return 4 + switchViewModel.selectedSectionFromAnotherVC[section]!
        } else if switchViewModel.selectedSectionFromAnotherVC.keys.contains(2) && section == 2 {
            return 4 + switchViewModel.selectedSectionFromAnotherVC[section]!
        }
        return 4
    }
}
//MARK: TableView data source
extension SwitchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
        cell.initializeData(section: indexPath.section, row: indexPath.row, delegate: self)
        cell.tableViewSwitch.tag = indexPath.row
        if let result = switchViewModel.checkAllSwitchStateEnabledOrNot(section: indexPath.section, noOfCell: tableView.numberOfRows(inSection: indexPath.section)) {
            if result {
                cell.tableViewSwitch.isOn = true
            } else {
                cell.tableViewSwitch.isOn = false
            }
        } else {
            if switchViewModel.switchStates[indexPath.section]  != nil && switchViewModel.switchStates[indexPath.section]![indexPath.row] == true {
                cell.tableViewSwitch.isOn = true
            } else {
                cell.tableViewSwitch.isOn = false
            }
        }
        return cell
    }
}
//MARK: Switch table view cell delegate
extension SwitchViewController: SwitchActionDelegate {
    func sectionSelected(section: [Int: Int]) {
        switchViewModel.selectedSectionFromAnotherVC = section
        tableView.reloadData()
    }
    
    func switchActionCompleted(switchState: Bool, section: Int, row: Int) {
        if switchViewModel.switchStates[section] == nil {
            switchViewModel.switchStates[section] = [Int : Bool]()
        }
        switchViewModel.switchStates[section]![row] = switchState
        if let result = switchViewModel.checkAllSwitchStateEnabledOrNot(section: section, noOfCell: tableView.numberOfRows(inSection: section)) {
            if result {
                switchViewModel.headerState[section] = true
            } else {
                switchViewModel.headerState[section] = false
            }
        } else if switchViewModel.headerState[section] == false{
            switchViewModel.headerState[section] = false
        } else {
            switchViewModel.headerState[section] = true
        }
        tableView.reloadData()
    }
}
