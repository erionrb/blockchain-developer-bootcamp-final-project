# Design Patterns

# Inter-Contract Execution
The MusichainNFT contract is not been used externally but it's access is made up by inter-contract execution from Marketplace contract.

# Inheritance and Interfaces

The MusichainNFT inherits the ERC1155 contract from the @openzepellin/contracts for secure and efficient token management.

# Access Control Design Patterns

Each MusichainNFT album contract deployed make use of the Ownable pattern, to make sure that only the ower can make changes on restricted functions of the contract.