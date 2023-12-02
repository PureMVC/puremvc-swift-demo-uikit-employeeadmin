//
//  UserFormView.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserForm: View, UserFormDispatcher {
    
    @StateObject private var viewModel = UserFormViewModel()

    @State var confirm: String?
    
    @State var department: Department?
    
    @State var isSheetPresented: Bool = false
    
    @State var exception: Exception?
    
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        VStack {
            
            HStack {
                TextField("First", text: Binding(
                        get: { viewModel.user?.first ?? "" },
                        set: { viewModel.user?.first = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                              
                TextField("Last", text: Binding(
                        get: { viewModel.user?.last ?? "" },
                        set: { viewModel.user?.last = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
            }
            
            HStack {
                TextField("Email", text: Binding(
                        get: { viewModel.user?.email ?? "" },
                        set: { viewModel.user?.email = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                
                TextField("Username", text: Binding(
                        get: { viewModel.user?.username ?? "" },
                        set: { viewModel.user?.username = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
            }
            
            HStack {
                SecureField("Password", text: Binding(
                        get: { viewModel.user?.password ?? "" },
                        set: { viewModel.user?.password = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.oneTimeCode)
                
                SecureField("Confirm Password", text: Binding(
                        get: { viewModel.confirm ?? "" },
                        set: { viewModel.confirm = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.oneTimeCode)
            }
            
            HStack {
                Picker(selection: $department, label: Text("")) {
                    ForEach(viewModel.departments, id: \.id) { department in
                        Text(department.name ?? "").tag(Optional(department))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
            }
        }
        .padding()
        .navigationTitle("User Form")
        .navigationBarItems(trailing: Button(action: {
            viewModel.user?.department = department
            if ((viewModel.user?.isValid(confirm: confirm)) != nil) {
                viewModel.saveOrUpdate()
            } else {
                fault(Exception(message: "Invalid Form Data."))
            }
        }) {
            Text(viewModel.user?.id == 0 ? "Save" : "Update" )
        })
        .onAppear {
            viewModel.dispatcher = self
            viewModel.user = user
            department = user.department
            viewModel.initialize()
        }
        .alert(isPresented: Binding(get:{ exception != nil }, set:{ _ in exception = nil })) {
            Alert(
                title: Text("Error"),
                message: Text(exception?.message ?? "An unknown error occurred."),
                primaryButton: .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }

        HStack {
            Button(action: { isSheetPresented.toggle() }) {
                HStack {
                    Text("User Roles")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .sheet(isPresented: $isSheetPresented) {
                            UserRole(viewModel.user) { user in
                                viewModel.user = user
                            }
                        }
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        
        Spacer()
    }
    
    var user: User
    
    var responder: ((User?) -> Void)?
          
    init(_ user: User, _ responder: ((User?) -> Void)?) {
        self.user = user
        self.responder = responder
    }
    
    func dismissView() {
        responder?(viewModel.user)
        presentationMode.wrappedValue.dismiss()
    }
    
    func fault(_ exception: Exception) {
        self.exception = exception
    }

}

struct UserFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserForm(User(id: 0), nil)
    }
}
