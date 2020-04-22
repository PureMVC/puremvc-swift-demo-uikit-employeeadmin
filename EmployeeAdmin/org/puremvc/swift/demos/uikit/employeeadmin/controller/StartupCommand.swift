//
//  StartupCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class StartupCommand: MacroCommand {
    
    /**
    Add the Subcommands to startup the PureMVC apparatus.
    
    Generally, it is best to prep the Model (mostly registering
    proxies) followed by preparation of the View (mostly registering
    Mediators).
    */
    override func initializeMacroCommand() {
        addSubCommand { PrepModelCommand() }
        addSubCommand { PrepViewCommand() }
    }
    
}
