import SwiftUI
import Combine
import sharedSample

struct SecureTextFieldWithControl: View {
    
    private let hint: String
    
    private let inputControl: InputControl
    
    @ObservedObject
    private var text: UnsafeObservableState<NSString>
    
    @ObservedObject
    private var error: UnsafeObservableState<StringDesc>
    
    @ObservedObject
    private var hasFocus: UnsafeMutableObservableState<KotlinBoolean>
    
    @ObservedObject
    private var enabled: UnsafeMutableObservableState<KotlinBoolean>
    
    @State
    private var keyboardOptions: KeyboardOptions
    
    @FocusState
    private var isFocused: Bool
    
    init(inputControl: InputControl, hint: String) {
        self.hint = hint
        self.inputControl = inputControl
        self.keyboardOptions = inputControl.keyboardOptions
        self.text = UnsafeObservableState(inputControl.text)
        self.error = UnsafeObservableState(inputControl.error)
        self.hasFocus = UnsafeMutableObservableState(inputControl.hasFocus)
        self.enabled = UnsafeMutableObservableState(inputControl.enabled)
    }
    
    var body: some View {
        VStack {
            SecureField(
                text: Binding {
                    String(text.value ?? "")
                } set: { value in
                    inputControl.onTextChanged(text:value)
                },
                prompt: Text(hint),
                label: {
                    Text("123")
                }
            )
            .textFieldStyle(.roundedBorder)
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                hasFocus.setValue(value: KotlinBoolean(value: newValue))
            }
            .disabled(!(enabled.value?.boolValue ?? false))
            .keyboardType(keyboardOptions.keyboardType.toUI())
            .submitLabel(keyboardOptions.imeAction.toUI())
            .textInputAutocapitalization(keyboardOptions.capitalization.toUI())
            .autocorrectionDisabled(!keyboardOptions.autoCorrect)
            
            if let error = error.value {
                Text(error.localized())
                    .foregroundColor(.red)
            }
        }
        .padding(4)
    }
}
