import SwiftUI
import SwiftData

struct ContractFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ContractFormViewModel

    init(contract: Contract? = nil) {
        if let contract {
            _viewModel = State(initialValue: ContractFormViewModel(contract: contract))
        } else {
            _viewModel = State(initialValue: ContractFormViewModel())
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contract Info") {
                    TextField("Title", text: $viewModel.title)
                    TextField("Vendor Name", text: $viewModel.vendorName)
                    Picker("Type", selection: $viewModel.contractType) {
                        ForEach(ContractType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section("Dates") {
                    DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    Stepper("Notice Period: \(viewModel.noticePeriodDays) days", value: $viewModel.noticePeriodDays, in: 1...365)
                }

                Section("Renewal") {
                    Toggle("Auto-Renews", isOn: $viewModel.autoRenews)
                    if viewModel.autoRenews {
                        Stepper("Renewal Term: \(viewModel.renewalTermMonths) months", value: $viewModel.renewalTermMonths, in: 1...60)
                    }
                }

                Section("Value") {
                    HStack {
                        TextField("Value", value: $viewModel.contractValue, format: .number)
                            .keyboardType(.decimalPad)
                        Picker("", selection: $viewModel.currency) {
                            Text("USD").tag("USD")
                            Text("EUR").tag("EUR")
                            Text("GBP").tag("GBP")
                            Text("CAD").tag("CAD")
                            Text("AUD").tag("AUD")
                        }
                        .labelsHidden()
                    }
                }

                Section("Owner") {
                    TextField("Owner Name", text: $viewModel.ownerName)
                    TextField("Owner Email", text: $viewModel.ownerEmail)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }

                Section("Notes") {
                    TextField("Notes", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Contract" : "New Contract")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save(using: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
