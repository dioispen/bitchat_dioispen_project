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
        #if os(macOS)
        #if canImport(Flutter)
        MacFlutterHostedView()
        #else
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
        #else
        #if canImport(Flutter)
        FlutterHostedView()
        #else
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
        #endif
    }
}

#if canImport(Flutter)
#if os(macOS)
struct MacFlutterHostedView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSViewController {
        if let appDelegate = NSApplication.shared.delegate as? MacAppDelegate,
           let engine = appDelegate.flutterEngine {
            return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        }

        let engine = FlutterEngine(name: "bitchat_flutter_engine")
        engine.run()
        GeneratedPluginRegistrant.register(with: engine)
        if let appDelegate = NSApplication.shared.delegate as? MacAppDelegate {
            appDelegate.flutterEngine = engine
        }
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // Update logic if needed
    }
}
#else
struct FlutterHostedView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
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
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
}
#endif
#endif
