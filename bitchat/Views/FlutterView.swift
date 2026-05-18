//
// FlutterView.swift
// bitchat
//
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI
import Flutter

/// SwiftUI wrapper for Flutter module
struct FlutterView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}
