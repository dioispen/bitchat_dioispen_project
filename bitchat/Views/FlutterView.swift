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
        #if canImport(Flutter)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let engine = appDelegate.flutterEngine {
            return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        }

        let engine = FlutterEngine(name: "bitchat_flutter_engine")
        engine.run()
        GeneratedPluginRegistrant.register(with: engine)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.flutterEngine = engine
        }
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        #else
        return UIViewController()
        #endif
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}
#endif
