import SwiftUI
import SwiftData
import VisionKit
import Vision

struct ScannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager()
    @State private var showingPaywall = false
    @State private var scannedText = ""
    @State private var isProcessing = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if VNDocumentCameraViewController.isSupported {
                    DocumentScannerRepresentable { text in
                        scannedText = text
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView(
                        "Scanner Not Available",
                        systemImage: "doc.text.viewfinder",
                        description: Text("Document scanning is not supported on this device")
                    )
                }
            }
            .navigationTitle("Scan Contract")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .overlay {
                if isProcessing {
                    ProgressView("Processing document...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

struct DocumentScannerRepresentable: UIViewControllerRepresentable {
    let onScanComplete: (String) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onScanComplete: onScanComplete)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let onScanComplete: (String) -> Void

        init(onScanComplete: @escaping (String) -> Void) {
            self.onScanComplete = onScanComplete
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var extractedText = ""
            for i in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: i)
                recognizeText(in: image) { text in
                    extractedText += text + "\n"
                    if i == scan.pageCount - 1 {
                        DispatchQueue.main.async {
                            self.onScanComplete(extractedText)
                            controller.dismiss(animated: true)
                        }
                    }
                }
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
        }

        private func recognizeText(in image: UIImage, completion: @escaping (String) -> Void) {
            guard let cgImage = image.cgImage else {
                completion("")
                return
            }

            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    completion("")
                    return
                }
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                completion(text)
            }
            request.recognitionLevel = .accurate

            DispatchQueue.global(qos: .userInitiated).async {
                try? VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            }
        }
    }
}
