// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Network

public protocol NetworkMonitorDelegate: AnyObject {
    func networkMontior(_ model: NetworkMonitor, stateChanged isConnected: Bool)
}

public final class NetworkMonitor: ObservableObject, @unchecked Sendable {
    private lazy var monitor = NWPathMonitor()
    private lazy var queue = DispatchQueue.global(qos: .utility)
    var isMonitoring: Bool = false
    private var isRequested: Bool = false
    public weak var delegate: NetworkMonitorDelegate?

    @Published public var state: NetworkIntensivity = .loading
    
    var serverUrl: String = "https://yalla.uz"

    public init(serverUrl: String, delegate: NetworkMonitorDelegate?) {
        self.serverUrl = serverUrl
        self.delegate = delegate
    }

    public var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    public func isReachable(completion: @escaping @Sendable (Bool) -> Void) {
        if isRequested {
            completion(false)
            return
        }

        var request = URLRequest(url: URL(string: serverUrl)!)
        request.httpMethod = "HEAD" // Optimized: HEAD instead of GET
        
        isRequested = true
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self else {
                completion(false)
                return
            }
            
            self.isRequested = false
            DispatchQueue.main.async {
                if error != nil {
                    self.state = .disconnected
                    completion(false)
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.state = .connected
                    completion(true)
                } else {
                    self.state = .disconnected
                    completion(false)
                }
            }
        }
        
        task.resume()
    }

    public func startMonitoring() {
        debugPrint("starting to monitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            debugPrint("path updated: \(path.status)")
            
            DispatchQueue.main.async {
                self.delegate?.networkMontior(self, stateChanged: path.status == .satisfied)
            }
        }

        monitor.start(queue: queue)
        isMonitoring = true
    }

    public func hasConnectionWithServer() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            isReachable { isReachable in
                continuation.resume(returning: isReachable)
            }
        }
    }

    public func stopMonitoring() {
        debugPrint("stopping to monitor")
        monitor.cancel()
        isMonitoring = false
    }
    
    deinit {
        debugPrint("deinitialized")
    }
}
