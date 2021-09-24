//
//  ContentView.swift
//  LoadingSwitch
//
//  Created by Quentin Cornu on 24/09/2021.
//

import SwiftUI

struct LoadingSwitch: View {
	
	// MARK: - Private properties
	
	@Binding private var orderMode: Mode
	
	@State private var currentMode: Mode = .on
	@State private var circleIsLoading = false
	@State private var trimStart: CGFloat = 0.0
	@State private var trimStop: CGFloat = 0.0
	@State private var canExitLoading = true
	@State private var loadingAnimationTimer: Timer?
	
	private var backgroundColor: Color {
		switch currentMode {
			case .off:
				return .red
			case .loading:
				return .gray
			case .on:
				return .green
		}
	}
	
	private var alignment: Alignment {
		switch currentMode {
			case .off:
				return .leading
			case .loading:
				return .center
			case .on:
				return .trailing
		}
	}
	
	// MARK: - Initializers
	
	init(mode: Binding<Mode>) {
		self._orderMode = mode
	}
	
	// MARK: - Views
	
	var body: some View {
		VStack {
			ZStack(alignment: alignment) {
				RoundedRectangle(cornerRadius: 15)
					.foregroundColor(backgroundColor)
				Circle()
					.frame(width: 26, height: 26)
					.padding(2)
					.foregroundColor(.white)
					.shadow(radius: 2)
				if currentMode == .loading {
					Circle()
						.trim(from: trimStart, to: trimStop)
						.stroke(style: StrokeStyle(lineWidth: 2))
						.rotation(.degrees(-90))
						.frame(width: 28, height: 28)
						.foregroundColor(.blue)
				}
			}
			.frame(width: currentMode == .loading ? 30 : 50, height: 30)
		}
		.onChange(of: orderMode, perform: { _ in
			if orderMode == .loading {
				updateCurrentMode()
				DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
					circleIsLoading = true
				}
			} else if currentMode == .loading {
				if canExitLoading {
					circleIsLoading = false
					updateCurrentMode()
				}
			} else {
				updateCurrentMode()
			}
		})
		.onChange(of: circleIsLoading, perform: { _ in
			if circleIsLoading {
				triggerLoadingAnimation()
				loadingAnimationTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
					triggerLoadingAnimation()
				}
			} else {
				loadingAnimationTimer?.invalidate()
			}
		})
		.onChange(of: canExitLoading, perform: { _ in
			if orderMode != .loading {
				updateCurrentMode()
			}
		})
	}
	
	enum Mode {
		case off
		case loading
		case on
	}
	
	// MARK: - Private methods
	
	private func updateCurrentMode() {
		withAnimation(.easeInOut(duration: 0.5)) {
			currentMode = orderMode
		}
	}
	
	private func triggerLoadingAnimation() {
		canExitLoading = false
		trimStop = 0.0
		trimStart = 0.0
		withAnimation(.easeInOut(duration: 0.75)) {
			trimStop = 1.0
		}
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
			withAnimation(.easeInOut(duration: 0.75)) {
				trimStart = 1.0
			}
			DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
				canExitLoading = true
			}
		}
	}
}

struct LoadingSwitch_Previews: PreviewProvider {
	
	static var previews: some View {
		Group {
			LoadingSwitch(mode: .constant(.off))
			LoadingSwitch(mode: .constant(.loading))
			LoadingSwitch(mode: .constant(.on))
		}
	}
}
