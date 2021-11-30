# Common Attack Protection Measures

# [SWC-118: Incorrect Constructor Name](https://swcregistry.io/docs/SWC-118)

This issue has been primarily addressed in the Solidity compiler in version 0.4.22. This version introduced a `constructor` keyword which specifies the constructor, rather than requiring the name of the function to match the contract name. It is therefore recommended to upgrade the contract to a recent version of the Solidity compiler and change to the new constructor declaration.

# [SWC-103: Floating Pragma](https://swcregistry.io/docs/SWC-103)

Contracts should be deployed with the same compiler version and flags that they have been tested with thoroughly. Locking the pragma helps to ensure that contracts do not accidentally get deployed using, for example, an outdated compiler version that might introduce bugs that affect the contract system negatively.