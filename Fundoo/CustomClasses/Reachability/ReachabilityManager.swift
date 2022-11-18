import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkStatus {
    static public let shared = NetworkStatus()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var isOn: Bool = true
    var connType: ConnectionType = .wifi
    var listener: ((_ status: Bool) -> ())?

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitor")
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { path in
            self.isOn = path.status == .satisfied
            self.listener?(self.isOn)
            
//            self.connType = self.checkConnectionTypeForPath(path)
        }
    }

    func stop() {
        self.monitor.cancel()
    }

//    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
//        if path.usesInterfaceType(.wifi) {
//            return .wifi
//        } else if path.usesInterfaceType(.wiredEthernet) {
//            return .ethernet
//        } else if path.usesInterfaceType(.cellular) {
//            return .cellular
//        }
//
//        return .unknown
//    }
}
