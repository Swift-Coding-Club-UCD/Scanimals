//
//  LaunchScreenView.swift
//  Scanimals
//
//  Created by Adam Lee on 5/27/25.
//

import SwiftUI

struct LaunchScreenView: View {
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()

      VStack(spacing: 16) {

        Text("Scanimals")
          .font(.largeTitle)
          .fontWeight(.bold)
      }
    }
  }
}
