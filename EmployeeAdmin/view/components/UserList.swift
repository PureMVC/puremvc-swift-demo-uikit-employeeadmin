//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserList: View, UserListDispatcher {
    
    @StateObject private var viewModel = UserListViewModel()
    
    @State private var exception: Exception?
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink(value: user) {
                        Text(user.givenName)
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        viewModel.deleteByIndex(index)
                    }
                }
            }
            .navigationTitle("UserList")
            .navigationBarItems(trailing: NavigationLink(destination: UserForm(User(id: 0)) { user in
                if let user {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation { viewModel.users.append(user) }
                    }
                }
            }) {
                Image(systemName: "plus.circle").imageScale(.large)
            })
            .navigationDestination(for: User.self, destination: {
                UserForm($0) { user in
                    if let user {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let index = viewModel.users.firstIndex(where: { $0.id == user.id }) {
                                withAnimation { viewModel.users[index] = user }
                            }
                        }
                    }
                }
            })
            .onAppear {
                viewModel.dispatcher = self
                if viewModel.users.isEmpty {
                    viewModel.initialize()
                }
            }
            .alert(isPresented: Binding(get: { exception != nil }, set: { _ in exception = nil })) {
                Alert(
                    title: Text("Error"),
                    message: Text(exception?.message ?? "An unknown error occurred."),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    func fault(_ exception: Exception) {
        self.exception = exception
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}

