//
//  DeptEnum.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class DeptEnum {
 
    static var NONE_SELECTED = DeptEnum(value: "--Select Department--", ordinal: -1)
    static var ACCT = DeptEnum(value: "Accounting", ordinal: 0)
    static var SALES = DeptEnum(value: "Sales", ordinal: 1)
    static var PLANT = DeptEnum(value: "Plant", ordinal: 2)
    static var SHIPPING = DeptEnum(value: "Shipping", ordinal: 3)
    static var QC = DeptEnum(value: "Quality Control", ordinal: 4)
    static var MARKETING = DeptEnum(value: "Marketing", ordinal: 5)
    static var HUMAN_RESOURCES = DeptEnum(value: "Human Resources", ordinal: 6)
    
    var value: String
    var ordinal: Int
    
    init(value: String, ordinal: Int) {
        self.value = value
        self.ordinal = ordinal
    }
    
    static var list: [DeptEnum] {
        return [
            ACCT,
            SALES,
            PLANT,
            SHIPPING,
            QC,
            MARKETING,
            HUMAN_RESOURCES
        ]
    }
    
    static var comboList: [DeptEnum] {
        var cList = DeptEnum.list
        cList.insert(NONE_SELECTED, atIndex: 0)
        return cList
    }
    
    func equals(deptEnum: DeptEnum) -> Bool {
        return ordinal == deptEnum.ordinal && value == deptEnum.value
    }
    
}