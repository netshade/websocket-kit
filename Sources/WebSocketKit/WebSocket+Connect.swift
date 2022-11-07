#if canImport(Network)
import Network
#endif

extension WebSocket {
    public static func connect(
        to url: String,
        headers: HTTPHeaders = [:],
        configuration: WebSocketClient.Configuration = .init(),
        on eventLoopGroup: EventLoopGroup,
        onUpgrade: @escaping (WebSocket) -> ()
    ) -> EventLoopFuture<Void> {
        guard let url = URL(string: url) else {
            return eventLoopGroup.next().makeFailedFuture(WebSocketClient.Error.invalidURL)
        }
        return self.connect(
            to: url,
            headers: headers,
            configuration: configuration,
            on: eventLoopGroup,
            onUpgrade: onUpgrade
        )
    }

    public static func connect(
        to url: URL,
        headers: HTTPHeaders = [:],
        configuration: WebSocketClient.Configuration = .init(),
        on eventLoopGroup: EventLoopGroup,
        onUpgrade: @escaping (WebSocket) -> ()
    ) -> EventLoopFuture<Void> {
        let scheme = url.scheme ?? "ws"
        return self.connect(
            scheme: scheme,
            host: url.host ?? "localhost",
            port: url.port ?? (scheme == "wss" ? 443 : 80),
            path: url.path,
            query: url.query,
            headers: headers,
            configuration: configuration,
            on: eventLoopGroup,
            onUpgrade: onUpgrade
        )
    }

    #if canImport(Network)
    public static func connect(
        scheme: String = "ws",
        host: String,
        port: Int = 80,
        endpoint: NWEndpoint? = nil,
        tcpOptions: NWProtocolTCP.Options? = nil,
        tlsOptions: NWProtocolTLS.Options? = nil,
        parameters: NWParameters? = nil,
        path: String = "/",
        query: String? = nil,
        headers: HTTPHeaders = [:],
        configuration: WebSocketClient.Configuration = .init(),
        on eventLoopGroup: EventLoopGroup,
        onUpgrade: @escaping (WebSocket) -> ()
    ) -> EventLoopFuture<Void> {
        return WebSocketClient(
            eventLoopGroupProvider: .shared(eventLoopGroup),
            configuration: configuration
        ).connect(
            scheme: scheme,
            host: host,
            port: port,
            endpoint: endpoint,
            tcpOptions: tcpOptions,
            tlsOptions: tlsOptions,
            parameters: parameters,
            path: path,
            query: query,
            headers: headers,
            onUpgrade: onUpgrade
        )
    }
    #else
    public static func connect(
        scheme: String = "ws",
        host: String,
        port: Int = 80,
        path: String = "/",
        query: String? = nil,
        headers: HTTPHeaders = [:],
        configuration: WebSocketClient.Configuration = .init(),
        on eventLoopGroup: EventLoopGroup,
        onUpgrade: @escaping (WebSocket) -> ()
    ) -> EventLoopFuture<Void> {
        return WebSocketClient(
            eventLoopGroupProvider: .shared(eventLoopGroup),
            configuration: configuration
        ).connect(
            scheme: scheme,
            host: host,
            port: port,
            endpoint: endpoint,
            tcpOptions: tcpOptions,
            tlsOptions: tlsOptions,
            parameters: parameters,
            path: path,
            query: query,
            headers: headers,
            onUpgrade: onUpgrade
        )
    }
    #endif
}
