public protocol FetchAccountRecordsUseCase: Sendable {
    func execute(accountNumber: String) async throws -> [HomeAccountRecord]
}
