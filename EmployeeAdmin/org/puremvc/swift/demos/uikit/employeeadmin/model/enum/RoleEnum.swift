//
//  RoleEnum.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RoleEnum {
    
    static var NONE_SELECTED = RoleEnum(value: "--None Selected--", ordinal: -1)
    static var ADMIN = RoleEnum(value: "Administrator", ordinal: 0)
    static var ACCT_PAY = RoleEnum(value: "Accounts Payable", ordinal: 1)
    static var ACCT_RCV = RoleEnum(value: "Accounts Receivable", ordinal: 2)
    static var EMP_BENEFITS = RoleEnum(value: "Employee Benefits", ordinal: 3)
    static var GEN_LEDGER = RoleEnum(value: "General Ledger", ordinal: 4)
    static var PAYROLL = RoleEnum(value: "Payroll", ordinal: 5)
    static var INVENTORY = RoleEnum(value: "Inventory", ordinal: 6)
    static var PRODUCTION = RoleEnum(value: "Production", ordinal: 7)
    static var QUALITY_CTL = RoleEnum(value: "Quality Control", ordinal: 8)
    static var SALES = RoleEnum(value: "Sales", ordinal: 9)
    static var ORDERS = RoleEnum(value: "Orders", ordinal: 10)
    static var CUSTOMERS = RoleEnum(value: "Customers", ordinal: 11)
    static var SHIPPING = RoleEnum(value: "Shipping", ordinal: 12)
    static var RETURNS = RoleEnum(value: "Returns", ordinal: 13)
    
    var value: String
    var ordinal: Int
    
    init(value: String, ordinal: Int) {
        self.value = value
        self.ordinal = ordinal
    }
    
    static var list: [RoleEnum] {
        return [
            ADMIN,
            ACCT_PAY,
            ACCT_RCV,
            EMP_BENEFITS,
            GEN_LEDGER,
            PAYROLL,
            INVENTORY,
            PRODUCTION,
            QUALITY_CTL,
            SALES,
            ORDERS,
            CUSTOMERS,
            SHIPPING,
            RETURNS
        ]
    }
    
    static var comboList: [RoleEnum] {
        var cList = RoleEnum.list
        cList.insert(NONE_SELECTED, atIndex: 0)
        return cList
    }
    
    func equals(roleEnum: RoleEnum) -> Bool {
        return ordinal == roleEnum.ordinal && value == roleEnum.value
    }
    
}
