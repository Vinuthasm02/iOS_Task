//
//  SwitchTableViewCell.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import UIKit

protocol SwitchActionDelegate : class {
    func switchActionCompleted(switchState: Bool, section: Int, row: Int)
    func sectionSelected(section: [Int: Int])
}

class SwitchTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var tableViewSwitch: UISwitch!
    
    //MARK: Properties
    private var delegate: SwitchActionDelegate?
    private var section: Int?
    private var row: Int?
    
    //MARK: Initializer
    func initializeData(section: Int, row: Int, delegate: SwitchActionDelegate?) {
        self.section = section
        self.row = row
        self.delegate = delegate
    }
    
    //MARK: Action
    @IBAction func switchTapped(_ sender: UISwitch) {
        delegate?.switchActionCompleted(switchState: sender.isOn, section: section ?? 0, row: row ?? 0)
    }
}
