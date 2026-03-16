public protocol HomeDepositRepository: Sendable {
    func fetchDeposits() async throws -> [HomeDeposit]
}
