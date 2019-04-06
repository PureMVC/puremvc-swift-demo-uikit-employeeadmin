//
//  PrepModelCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class PrepModelCommand: SimpleCommand {
    
    /**
    Prepare the Model.
    */
    override func execute(_ notification: INotification) {
        // Create User Proxy,
        let userProxy = UserProxy()
        
        //Populate it with dummy data
        userProxy.addItem(UserVO(username: "lstooge", fname: "Larry", lname: "Stooge", email: "larry@stooges.com", password: "ijk456", department: DeptEnum.ACCT))
        userProxy.addItem(UserVO(username: "cstooge", fname: "Curly", lname: "Stooge", email: "curly@stooges.com", password: "xyz987", department: DeptEnum.SALES))
        userProxy.addItem(UserVO(username: "mstooge", fname: "Moe", lname: "Stooge", email: "moe@stooges.com", password: "abc123", department: DeptEnum.PLANT))
        
        // register it
        facade.registerProxy(userProxy)
        
        // Create Role Proxy
        let roleProxy = RoleProxy()
        
        //Populate it with dummy data 
        roleProxy.addItem(RoleVO(username: "lstooge", roles: [RoleEnum.PAYROLL, RoleEnum.EMP_BENEFITS]))
        roleProxy.addItem(RoleVO(username: "cstooge", roles: [RoleEnum.ACCT_PAY, RoleEnum.ACCT_RCV, RoleEnum.GEN_LEDGER]))
        roleProxy.addItem(RoleVO(username: "mstooge", roles: [RoleEnum.PRODUCTION, RoleEnum.SALES, RoleEnum.SHIPPING]))
        
        // register it
        facade.registerProxy(roleProxy)
    }
    
}
