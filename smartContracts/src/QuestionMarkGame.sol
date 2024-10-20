// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

// 0,1,2,3
// a,b,c,d
// 0000, 0130, 1022 , ...\

uint256 constant NUM_CARDS = 4 ** 4;
uint constant BOARD_WIDTH = 3;
uint constant COLUMN = 0;
uint constant ROW = 1;
uint constant BOTTOM_LEFT = 0;
uint constant BOTTOM_RIGHT = 1;
uint constant TOP_RIGHT = 2;
uint constant TOP_LEFT = 3;

contract QuestionMarkGame {

    mapping(uint => address) winnerPerBoard;
    mapping(uint => mapping(address => uint[])) targetCardsGuessedPerBoardPerPlayer;
    mapping(uint => mapping(address => mapping(uint => uint[2]))) guessPerBoardPerPlayerPerTargetCard;

    function isGuessCorrect(uint[BOARD_WIDTH][BOARD_WIDTH] memory board, uint targetCard, uint[2] memory guessCoordinates) public pure returns (bool) {
        require(0 < guessCoordinates[COLUMN]);
        require(guessCoordinates[COLUMN] < 2*BOARD_WIDTH);
        require(0 < guessCoordinates[ROW]);
        require(guessCoordinates[ROW] < 2*BOARD_WIDTH);

        if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 1) {
            // exact card
            uint boardCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            return targetCard == boardCard;
        } else if (guessCoordinates[COLUMN] % 2 == 0 && guessCoordinates[ROW] % 2 == 0) {
            // 4 cards
            uint bottomLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2 - 1];
            uint bottomRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            uint topLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint topRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            return bottomLeftCard[TOP_RIGHT] == targetCard[BOTTOM_LEFT] && bottomRightCard[TOP_LEFT] == targetCard[BOTTOM_RIGHT] && topLeftCard[BOTTOM_RIGHT] == targetCard[TOP_LEFT] && topRightCard[BOTTOM_LEFT] == targetCard[TOP_RIGHT];
        } else if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 0) {
            // 2 cards
            uint bottomCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            uint topCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            return bottomCard[TOP_LEFT] == targetCard[BOTTOM_LEFT] && bottomCard[TOP_RIGHT] == targetCard[BOTTOM_RIGHT] && topCard[BOTTOM_LEFT] == targetCard[TOP_LEFT] && topCard[BOTTOM_RIGHT] == targetCard[TOP_RIGHT];
        } else
            // 2 cards
            uint leftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint rightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            return leftCard[BOTTOM_RIGHT] == targetCard[BOTTOM_LEFT] && rightCard[BOTTOM_LEFT] == targetCard[BOTTOM_RIGHT] && leftCard[TOP_RIGHT] == targetCard[TOP_LEFT] && rightCard[TOP_LEFT] == targetCard[TOP_RIGHT];
        }
    }

    // Maps the 4 values of the card to a single number (0 to 255)
    function cardToNumber(uint256[4] memory cardValues) public pure returns (uint256) {
        require(cardValues.length == 4, "Card must have exactly 4 values.");
        uint256 result = 0;
        for (uint256 i = 0; i < 4; i++) {
            require(cardValues[i] < 4, "Each value must be between 0 and 3.");
            result += cardValues[i] * uint256(4**i);
        }
        return result;
    }

    // Maps a number (0 to 255) back to the 4 values of the card
    function numberToCard(uint256 number) public pure returns (uint256[4] memory) {
        require(number < 256, "Number must be between 0 and 255.");
        uint256[4] memory cardValues;
        for (uint256 i = 0; i < 4; i++) {
            cardValues[i] = number % 4;
            number /= 4;
        }
        return cardValues;
    }
    
    function generatePermutation(uint256 N, uint256 seed) public pure returns (uint256[NUM_CARDS] memory permutation) {
        for (uint256 i = 0; i < N; i++) {
            permutation[i] = i;
        }
        for (uint256 i = N - 1; i > 0; i--) {
            uint256 j = random(seed, i + 1);
            (permutation[i], permutation[j]) = (permutation[j], permutation[i]);
            seed = uint256(keccak256(abi.encodePacked(seed, i)));
        }

    }

    function random(uint256 seed, uint256 upperBound) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed))) % upperBound;
    }
}
