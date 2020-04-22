//
//  DeptEnum.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

enum DeptEnum: String {
    
    case NONE_SELECTED = "--Select Department"
    case ACCT = "Accounting"
    case SALES = "Sales"
    case PLANT = "Plant"
    case SHIPPING = "Shipping"
    case QC = "QualityControl"
    case MARKETING = "Marketing"
    case HUMAN_RESOURCES = "Human Resources"
    
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
        cList.insert(NONE_SELECTED, at: 0)
        return cList
    }
    
    func equals(_ deptEnum: DeptEnum) -> Bool {
        return self == deptEnum
    }
}
