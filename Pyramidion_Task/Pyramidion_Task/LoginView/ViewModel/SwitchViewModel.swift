//
//  SwitchViewModel.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import Foundation

class SwitchViewModel {
    
    //MARK: Properties
    var switchStates = [Int: [Int: Bool]]()
    var headerState = [Int: Bool]()
    var selectedSections = [Int: Int]()
    var selectedSectionFromAnotherVC = [Int: Int]()
    
    func checkHeaderStateAndEnableAllSwitch(section: Int) -> Bool{
        if !headerState.isEmpty && headerState[section] != nil && !headerState[section]! {
            return false
        }
        return true
    }
    
    func checkSwitchStateAndEnableHeaderSwitch(section: Int, noOfCell: Int) -> Bool {
        var isAllCellSwitchEnabled = [Int: Bool]()
        for i in 0..<noOfCell {
            if !switchStates.isEmpty && switchStates[section] != nil && switchStates[section]![i] != nil && !switchStates[section]![i]! {
                isAllCellSwitchEnabled[i] = false
            } else {
                isAllCellSwitchEnabled[i] = true
            }
        }
        if isAllCellSwitchEnabled.values.contains(false) {
            return false
        }
        return true
    }
    
    func checkAllSwitchStateEnabledOrNot(section: Int, noOfCell: Int) -> Bool? {
        var isAllCellSwitchEnabled = [Int: Bool]()
        var isAllCellSwitchDisabled = [Int: Bool]()
        for i in 0..<noOfCell {
            if !switchStates.isEmpty && switchStates[section] != nil && switchStates[section]![i] != nil && !switchStates[section]![i]! {
                isAllCellSwitchDisabled[i] = false
            } else {
                isAllCellSwitchEnabled[i] = true
            }
        }
        if isAllCellSwitchDisabled.values.contains(false) && noOfCell == isAllCellSwitchDisabled.count {
            return false
        }
        if isAllCellSwitchEnabled.values.contains(true) && noOfCell == isAllCellSwitchEnabled.count {
            return true
        }
        return nil
    }
}
