//
//  PrepModelCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
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
        userProxy.addItem(UserVO(username: "lstooge", first: "Larry", last: "Stooge", email: "larry@stooges.com", password: "ijk456", department: .ACCT))
        userProxy.addItem(UserVO(username: "cstooge", first: "Curly", last: "Stooge", email: "curly@stooges.com", password: "xyz987", department: .SALES))
        userProxy.addItem(UserVO(username: "mstooge", first: "Moe", last: "Stooge", email: "moe@stooges.com", password: "abc123", department: .PLANT))
        
        // register it
        facade.registerProxy(userProxy)
        
        // Create Role Proxy
        let roleProxy = RoleProxy()
        
        //Populate it with dummy data 
        roleProxy.addItem(RoleVO(username: "lstooge", roles: [.PAYROLL, .EMP_BENEFITS]))
        roleProxy.addItem(RoleVO(username: "cstooge", roles: [.ACCT_PAY, .ACCT_RCV, .GEN_LEDGER]))
        roleProxy.addItem(RoleVO(username: "mstooge", roles: [.PRODUCTION, .SALES, .SHIPPING]))
        
        // register it
        facade.registerProxy(roleProxy)
    }
    
}
