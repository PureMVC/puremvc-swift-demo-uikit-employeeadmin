//
//  UserRoleView.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserRole: View, UserRoleDispatcher {
    
    @StateObject var viewModel = UserRoleViewModel()
    
    @State var error: Error?
    
    var body: some View {
        VStack {
            Text("User Roles").font(.headline).padding()
            
            Divider()
            
            List(viewModel.roles) { role in
                HStack {
                    Text(role.name ?? "").foregroundColor(.black)
                    Spacer()
                    if let user = viewModel.user, let hasRole = user.roles?.contains { $0.id == role.id }, hasRole {
                       Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = viewModel.user?.roles?.firstIndex(where: { $0.id == role.id }) {
                        viewModel.user?.roles?.remove(at: index)
                    } else {
                        viewModel.user?.roles?.append(role)
                    }
                    responder?(viewModel.user)
                }
            }
            .onAppear {
                viewModel.user = user
                viewModel.initialize()
            }
            .alert(isPresented: Binding(get:{ error != nil }, set:{ _ in error = nil })) {
                Alert(
                    title: Text("Error"),
                    message: Text(((error as? Exception)?.message ?? error?.localizedDescription) ?? "An unknown error occurred."),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    var user: User?
    
    var responder: ((User?) -> Void)?
    
    init(_ user: User?, responder: ((User?) -> Void)?) {
        self.user = user
        self.responder = responder
    }
    
    func fault(_ error: Error) {
        self.error = error
    }
}

struct UserRoleView_Previews: PreviewProvider {
    static var previews: some View {
        UserRole(User(id: 0), responder: nil)
    }
}
