public protocol HomeAccountRepository: Sendable {
    func fetchAccounts() async throws -> [HomeAccount]
    func fetchAccountRecords(accountNumber: String) async throws -> [HomeAccountRecord]
}
