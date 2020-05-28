//
//  RoleEnum.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

enum RoleEnum: String {
    
    case NONE_SELECTED = "--None Selected--"
    case ADMIN = "Administrator"
    case ACCT_PAY = "Accounts Payable"
    case ACCT_RCV = "Accounts Receivable"
    case EMP_BENEFITS = "Employee Benefits"
    case GEN_LEDGER = "General Ledger"
    case PAYROLL = "Payroll"
    case INVENTORY = "Inventory"
    case PRODUCTION = "Production"
    case QUALITY_CTL = "Quality Control"
    case SALES = "Sales"
    case ORDERS = "Orders"
    case CUSTOMERS = "Customers"
    case SHIPPING = "Shipping"
    case RETURNS = "Returns"
    
    static var list: [RoleEnum] {
        [
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
        cList.insert(NONE_SELECTED, at: 0)
        return cList
    }
    
    func equals(_ roleEnum: RoleEnum) -> Bool {
        self == roleEnum
    }
}
