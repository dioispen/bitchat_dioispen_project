//
// FlutterView.swift
// bitchat
//
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI
#if canImport(Flutter)
import Flutter
#endif

/// SwiftUI wrapper for Flutter module
struct FlutterView: View {
    var body: some View {
        #if canImport(Flutter)
        FlutterHostedView()
        #else
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
    }
}

#if canImport(Flutter)
struct FlutterHostedView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        FlutterViewController(project: nil, nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}
#endif
