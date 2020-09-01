//
//  ThirdViewController.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var dropDownTableView: UITableView!
    
    //MARK: Properties
    private var thirdViewModel = ThirdViewModel()
    private var delegate: SwitchActionDelegate?
    
    //MARK: Initializer
    func initializeData(delegate: SwitchActionDelegate?) {
        self.delegate = delegate
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: Actions
    @IBAction func dropDownClicked(_ sender: UIButton) {
        dropDownTableView.isHidden = false
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
        delegate?.sectionSelected(section: thirdViewModel.selectedSections)
    }
}
//MARK: table view deleagtes
extension ThirdViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if thirdViewModel.selectedSections[indexPath.row] == nil {
            thirdViewModel.selectedSections[indexPath.row] = 0
        }
        thirdViewModel.selectedSections[indexPath.row]! += 1
        dropDownTableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
//MARK: TableView data source
extension ThirdViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
        cell.sectionLabel.text = String(indexPath.row)
        return cell
    }
}
