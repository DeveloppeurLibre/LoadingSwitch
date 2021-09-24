//
//  LoadingSwitchApp.swift
//  LoadingSwitch
//
//  Created by Quentin Cornu on 24/09/2021.
//

import SwiftUI

@main
struct LoadingSwitchApp: App {
	
	@State private var mode = LoadingSwitch.Mode.off
	
	var body: some Scene {
		WindowGroup {
			VStack(spacing: 56) {
				LoadingSwitch(mode: $mode)
					.scaleEffect(3)
				HStack {
					Button("Off") {
						withAnimation(.easeIn(duration: 2)) {
							mode = .off
						}
					}
					Button("Load") {
						withAnimation(.easeIn(duration: 2)) {
							mode = .loading
						}
					}
					Button("On") {
						withAnimation(.easeIn(duration: 2)) {
							mode = .on
						}
					}
				}
			}
		}
	}
}
