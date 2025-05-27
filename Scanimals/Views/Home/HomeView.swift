//
//  HomeView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//
import SwiftUI

struct HomeView: View {
  @EnvironmentObject var homeVM: HomeViewModel

  var body: some View {
    NavigationView {
      List {
        ForEach(homeVM.scannedItems) { animal in
          NavigationLink(destination: InfoView(animal: animal)) {
            ScannedAnimalView(animal: animal)
          }
        }
      }
      .toolbar {

        ToolbarItem(placement: .principal) {
          Text("Scanimals")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.vertical, 5)
        }
      }
    }
  }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
