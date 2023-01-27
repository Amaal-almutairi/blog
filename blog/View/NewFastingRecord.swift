//
//  NewFastingRecord.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import SwiftUI

struct NewFastingRecord: View {
    @StateObject private var viewModel = NewFastingViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section {
                DatePicker("start", selection: $viewModel.fasting.start)
                DatePicker("end", selection: $viewModel.fasting.end)
            }

            Section {
                Picker("goal", selection: $viewModel.fasting.goal) {
                    ForEach([16, 18, 23], id: \.self) { hours in
                        Text(String(hours))
                            .tag(hours * 3600)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("save") {
                    Task {
                        await viewModel.save()
                        dismiss()
                    }
                }.disabled(viewModel.isSaving)
            }
        }
        .navigationTitle("newFasting")
    }
}

struct NewFastingRecord_Previews: PreviewProvider {
    static var previews: some View {
        NewFastingRecord()
    }
}
