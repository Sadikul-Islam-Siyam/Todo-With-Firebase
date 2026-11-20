import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isCreatingAccount = false

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 58))
                .foregroundStyle(.indigo)

            VStack(spacing: 6) {
                Text("Daylist")
                    .font(.largeTitle.bold())
                Text("A simple place to organize your day.")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 14) {
                TextField("Email address", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password (at least 6 characters)", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let message = authViewModel.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    if isCreatingAccount {
                        authViewModel.signUp(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
                    } else {
                        authViewModel.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
                    }
                } label: {
                    HStack {
                        if authViewModel.isLoading { ProgressView().tint(.white) }
                        Text(isCreatingAccount ? "Create account" : "Log in")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                }
                .buttonStyle(.borderedProminent)
                .disabled(authViewModel.isLoading || email.isEmpty || password.count < 6)

                Button(isCreatingAccount ? "Already have an account? Log in" : "New here? Create an account") {
                    authViewModel.errorMessage = nil
                    isCreatingAccount.toggle()
                }
                .font(.footnote)
            }
            .padding(22)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))

            Spacer()
            Text("Your tasks are saved securely to your account.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
        }
        .padding()
    }
}
