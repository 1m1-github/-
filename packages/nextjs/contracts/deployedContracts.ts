/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  545: {
    QuestionMarkGame: {
      address: "0x1266931A43d8784388D75affBcF9EB4328E02607",
      abi: [
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "claimWin",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "generatePermutation",
          outputs: [
            {
              internalType: "uint256[7][7]",
              name: "board",
              type: "uint256[7][7]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "guess",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          name: "numCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "viewNumCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          name: "winnerPerBoard",
          outputs: [
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
      ],
      inheritedFunctions: {},
    },
  },
  31337: {
    QuestionMarkGame: {
      address: "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
      abi: [
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "claimWin",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "generatePermutation",
          outputs: [
            {
              internalType: "uint256[7][7]",
              name: "board",
              type: "uint256[7][7]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "guess",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          name: "numCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "viewNumCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          name: "winnerPerBoard",
          outputs: [
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
      ],
      inheritedFunctions: {},
    },
  },
  11155111: {
    QuestionMarkGame: {
      address: "0x1266931A43d8784388D75affBcF9EB4328E02607",
      abi: [
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "claimWin",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "generatePermutation",
          outputs: [
            {
              internalType: "uint256[7][7]",
              name: "board",
              type: "uint256[7][7]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "guess",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          name: "numCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "viewNumCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          name: "winnerPerBoard",
          outputs: [
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
      ],
      inheritedFunctions: {},
    },
  },
  37084624: {
    QuestionMarkGame: {
      address: "0x1266931A43d8784388D75affBcF9EB4328E02607",
      abi: [
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "claimWin",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "generatePermutation",
          outputs: [
            {
              internalType: "uint256[7][7]",
              name: "board",
              type: "uint256[7][7]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "guess",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          name: "numCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "viewNumCorrectPerBoardPerPlayer",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          name: "winnerPerBoard",
          outputs: [
            {
              internalType: "address",
              name: "",
              type: "address",
            },
          ],
          stateMutability: "view",
          type: "function",
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
