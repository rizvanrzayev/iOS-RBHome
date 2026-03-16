import Foundation
import RBNavigation

public final class HomeRouter: ObservableObject {
    public let router = RBRouter<HomeRoute>()
    public var selectedProductId: String?

    public init() {}
}
