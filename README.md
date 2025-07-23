## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
forge test --match-test testPriceFeedVersionIsAccurate -vvvvv --fork-url $SEPOLIA_RPC_URL --> great way to simulate actual on chain, great way easy to test our contract
forge test --match-test testPriceFeedVersionIsAccurate -vvvvv --> full stack trace and depth debugging info
forge coverage  --fork-url $SEPOLIA_RPC_URL --> show us how much of code are testing to the moment right now (how much of our test suite, how much code is in red line)
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### to install chainlink-brownie-contracts from gitHubRepo 
1. run in terminal `forge install smartcontractkit/chainlink-brownie-contracts@`put here latest version in this case is 1.3.0` --no-commit`


    - ZkSyncChainChecker --> this is the tool/package you can use to only run certain test on ZK SYNC or test on other EVM CHAINS 
    - FoundryZkSyncChecker --> and this is what can use to only run certain test on VANILLA FOUNDRY or only run certain test on ZK SYNC FOUNDRY  

####

1. Proper README ✅

2. Integration tests ✅
    1. PIT STOP! How to make running these script easier?? ✅

3. Programatic verification ✅

4. Push to GitHub
