public struct HomeProfile: Sendable {
    public let firstName: String
    public let lastName: String
    public let photoBase64: String?

    public var initials: String {
        let f = firstName.first.map(String.init) ?? ""
        let l = lastName.first.map(String.init) ?? ""
        return (f + l).uppercased()
    }

    public var fullName: String { "\(firstName) \(lastName)" }

    public init(firstName: String, lastName: String, photoBase64: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.photoBase64 = photoBase64
    }
}
