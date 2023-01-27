//
//  FastingHistoryView.swift
//  blog
//
//  Created by Amaal Almutairi on 03/07/1444 AH.
//

import SwiftUI

struct FastingHistoryView: View {
    @StateObject private var viewModel = FastingHistoryViewModel()

    var body: some View {
        List(viewModel.history, id: \.self) { fasting in
            VStack(alignment: .leading) {
                Text(fasting.start, style: .time)
                Text(fasting.end, style: .time)
            }
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .refreshable {
            await viewModel.fetch()
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct FastingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FastingHistoryView()
    }
}
