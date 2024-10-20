//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

uint constant WIN_THRESHOLD = 3;
uint constant NUM_CARDS = 4 ** 4;
uint constant BOARD_WIDTH = 7;
uint constant COLUMN = 0;
uint constant ROW = 1;
uint constant BOTTOM_LEFT = 0;
uint constant BOTTOM_RIGHT = 1;
uint constant TOP_LEFT = 2;
uint constant TOP_RIGHT = 3;
address constant ZERO_ADDRESS = address(0);

contract QuestionMarkGame {

    mapping(uint => address) public winnerPerBoard;
    mapping(uint => mapping(uint => mapping(address => bool))) guessedPerBoardPerTargetCardPerPlayer;
    mapping(uint => mapping(address => uint)) public numCorrectPerBoardPerPlayer;
    
    function viewNumCorrectPerBoardPerPlayer(uint seed, address user) public view returns (uint) {
        console.log('viewNumCorrectPerBoardPerPlayer, seed', seed);
        console.log('viewNumCorrectPerBoardPerPlayer, msg.sender', msg.sender);
        console.log('viewNumCorrectPerBoardPerPlayer, user', user);
        console.log('viewNumCorrectPerBoardPerPlayer, numCorrectPerBoardPerPlayer[seed][user]', numCorrectPerBoardPerPlayer[seed][user]);
        return numCorrectPerBoardPerPlayer[seed][user];
    }

    function check(uint targetCard, uint[2] memory guessCoordinates) private pure {
        console.log('check, targetCard', targetCard);
        console.log('check, guessCoordinates[0]', guessCoordinates[0]);
        console.log('check, guessCoordinates[1]', guessCoordinates[1]);
        require(targetCard < NUM_CARDS, 'A');
        require(0 < guessCoordinates[COLUMN], 'B');
        require(guessCoordinates[COLUMN] < 2*BOARD_WIDTH, 'C');
        require(0 < guessCoordinates[ROW], 'D');
        require(guessCoordinates[ROW] < 2*BOARD_WIDTH, 'E');
    }

    function claimWin(uint seed) public {
        if (winnerPerBoard[seed] == ZERO_ADDRESS) return;
        if (numCorrectPerBoardPerPlayer[seed][msg.sender] < WIN_THRESHOLD) return;
        winnerPerBoard[seed] = msg.sender;
    }

    function guess(uint seed, uint targetCard, uint[2] memory guessCoordinates) public {
        console.log('guess, msg.sender', msg.sender);
        console.log('guess, seed', seed);
        console.log('guess, targetCard', targetCard);
        console.log('guess, guessCoordinates[0]', guessCoordinates[0]);
        console.log('guess, guessCoordinates[1]', guessCoordinates[1]);
        console.log('guess, numCorrectPerBoardPerPlayer[seed][msg.sender]', numCorrectPerBoardPerPlayer[seed][msg.sender]);
        
        check(targetCard, guessCoordinates);
        console.log('guess, after check');

        if (guessedPerBoardPerTargetCardPerPlayer[seed][targetCard][msg.sender]) return;
        console.log('guess, not guessed yet');
        guessedPerBoardPerTargetCardPerPlayer[seed][targetCard][msg.sender] = true;
        uint256[BOARD_WIDTH][BOARD_WIDTH] memory board = generatePermutation(seed);
        if (isGuessCorrect(board, targetCard, guessCoordinates)) {
            console.log('guess, correct');
            console.log('guess, numCorrectPerBoardPerPlayer[seed][msg.sender]', numCorrectPerBoardPerPlayer[seed][msg.sender]);
            numCorrectPerBoardPerPlayer[seed][msg.sender]++;
            console.log('guess, numCorrectPerBoardPerPlayer[seed][msg.sender]', numCorrectPerBoardPerPlayer[seed][msg.sender]);
        }
    }

    function rotateCard(uint card) private pure returns (uint rotatedCard) {
        // clockwise
        uint[4] memory cardValues = numberToCard(card);
        uint[4] memory rotatedCardValues;
        rotatedCardValues[BOTTOM_LEFT] = cardValues[BOTTOM_RIGHT];
        rotatedCardValues[BOTTOM_RIGHT] = cardValues[TOP_RIGHT];
        rotatedCardValues[TOP_RIGHT] = cardValues[TOP_LEFT];
        rotatedCardValues[TOP_LEFT] = cardValues[BOTTOM_LEFT];
        rotatedCard = cardToNumber(rotatedCardValues);
    }

    function isGuessCorrect(uint[BOARD_WIDTH][BOARD_WIDTH] memory board, uint targetCard, uint[2] memory guessCoordinates) private pure returns (bool) {
        console.log('isGuessCorrect, targetCard', targetCard);
        console.log('isGuessCorrect, guessCoordinates[0]', guessCoordinates[0]);
        console.log('isGuessCorrect, guessCoordinates[1]', guessCoordinates[1]);

        console.log('isGuessCorrect, 0,0 card', board[0][0]);

        check(targetCard, guessCoordinates);
console.log('isGuessCorrect, after check');
        uint256[4] memory targetCardValues = numberToCard(targetCard);
        console.log('isGuessCorrect, targetCardValues[BOTTOM_LEFT]', targetCardValues[BOTTOM_LEFT]);
        console.log('isGuessCorrect, targetCardValues[BOTTOM_RIGHT]', targetCardValues[BOTTOM_RIGHT]);
        console.log('isGuessCorrect, targetCardValues[TOP_RIGHT]', targetCardValues[TOP_RIGHT]);
        console.log('isGuessCorrect, targetCardValues[TOP_LEFT]', targetCardValues[TOP_LEFT]);

        console.log('isGuessCorrect, numberToCard(board[0][0])[BOTTOM_LEFT]', numberToCard(board[0][0])[BOTTOM_LEFT]);
        console.log('isGuessCorrect, numberToCard(board[0][0])[BOTTOM_RIGHT]', numberToCard(board[0][0])[BOTTOM_RIGHT]);
        console.log('isGuessCorrect, numberToCard(board[0][0])[TOP_RIGHT]', numberToCard(board[0][0])[TOP_RIGHT]);
        console.log('isGuessCorrect, numberToCard(board[0][0])[TOP_LEFT]', numberToCard(board[0][0])[TOP_LEFT]);

        if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 1) {
            console.log('isGuessCorrect, c1');
            // exact card
            // uint boardCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint boardCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2];
            if (targetCard == boardCard) return true;
            targetCard = rotateCard(targetCard);
            if (targetCard == boardCard) return true;
            targetCard = rotateCard(targetCard);
            if (targetCard == boardCard) return true;
            targetCard = rotateCard(targetCard);
            if (targetCard == boardCard) return true;
            return false;
        } else if (guessCoordinates[COLUMN] % 2 == 0 && guessCoordinates[ROW] % 2 == 0) {
            console.log('isGuessCorrect, c2');
            // 4 cards
            uint bottomLeftCard = board[guessCoordinates[ROW] / 2 - 1][guessCoordinates[COLUMN] / 2 - 1];
            // uint bottomLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2 - 1];
            uint256[4] memory bottomLeftCardValues = numberToCard(bottomLeftCard);
            uint bottomRightCard = board[guessCoordinates[ROW] / 2-1][guessCoordinates[COLUMN] / 2];
            // uint bottomRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            uint256[4] memory bottomRightCardValues = numberToCard(bottomRightCard);
            uint topLeftCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2-1];
            // uint topLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint256[4] memory topLeftCardValues = numberToCard(topLeftCard);
            uint topRightCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2];
            // uint topRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory topRightCardValues = numberToCard(topRightCard);
            if (bottomLeftCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_LEFT] && bottomRightCardValues[TOP_LEFT] == targetCardValues[BOTTOM_RIGHT] && topLeftCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_LEFT] && topRightCardValues[BOTTOM_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomLeftCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_LEFT] && bottomRightCardValues[TOP_LEFT] == targetCardValues[BOTTOM_RIGHT] && topLeftCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_LEFT] && topRightCardValues[BOTTOM_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomLeftCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_LEFT] && bottomRightCardValues[TOP_LEFT] == targetCardValues[BOTTOM_RIGHT] && topLeftCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_LEFT] && topRightCardValues[BOTTOM_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomLeftCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_LEFT] && bottomRightCardValues[TOP_LEFT] == targetCardValues[BOTTOM_RIGHT] && topLeftCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_LEFT] && topRightCardValues[BOTTOM_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            return false;
        } else if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 0) {
            console.log('isGuessCorrect, c3');
            // 2 cards
            uint bottomCard = board[guessCoordinates[ROW] / 2-1][guessCoordinates[COLUMN] / 2];
            // uint bottomCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            // console.log('isGuessCorrect, guessCoordinates[COLUMN] / 2', guessCoordinates[COLUMN] / 2);
            // console.log('isGuessCorrect, guessCoordinates[ROW] / 2 - 1', guessCoordinates[ROW] / 2 - 1);
            // console.log('isGuessCorrect, board[0][0]', board[0][0]);
            // console.log('isGuessCorrect, board[1][1]', board[1][1]);
            // console.log('isGuessCorrect, board[4][0]', board[4][0]);
            // console.log('isGuessCorrect, board[4][1]', board[4][1]);
            // console.log('isGuessCorrect, board[4][2]', board[4][2]);
            // console.log('isGuessCorrect, board[4][3]', board[4][3]);
            // console.log('isGuessCorrect, board[0][1]', board[0][1]);
            // console.log('isGuessCorrect, board[0][2]', board[0][2]);
            // console.log('isGuessCorrect, board[0][3]', board[0][3]);
            // console.log('isGuessCorrect, board[0][4]', board[0][4]);
            uint256[4] memory bottomCardValues = numberToCard(bottomCard);
            uint topCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2];
            // uint topCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory topCardValues = numberToCard(topCard);
            // console.log('isGuessCorrect, bottomCard', bottomCard);
            // console.log('isGuessCorrect, topCard', topCard);
            // console.log('isGuessCorrect, bottomCardValues[TOP_LEFT]', bottomCardValues[TOP_LEFT]);
            // console.log('isGuessCorrect, bottomCardValues[TOP_RIGHT]', bottomCardValues[TOP_RIGHT]);
            // console.log('isGuessCorrect, topCardValues[BOTTOM_LEFT]', topCardValues[BOTTOM_LEFT]);
            // console.log('isGuessCorrect, topCardValues[BOTTOM_RIGHT]', topCardValues[BOTTOM_RIGHT]);
            if (bottomCardValues[TOP_LEFT] == targetCardValues[BOTTOM_LEFT] && bottomCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_RIGHT] && topCardValues[BOTTOM_LEFT] == targetCardValues[TOP_LEFT] && topCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomCardValues[TOP_LEFT] == targetCardValues[BOTTOM_LEFT] && bottomCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_RIGHT] && topCardValues[BOTTOM_LEFT] == targetCardValues[TOP_LEFT] && topCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomCardValues[TOP_LEFT] == targetCardValues[BOTTOM_LEFT] && bottomCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_RIGHT] && topCardValues[BOTTOM_LEFT] == targetCardValues[TOP_LEFT] && topCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (bottomCardValues[TOP_LEFT] == targetCardValues[BOTTOM_LEFT] && bottomCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_RIGHT] && topCardValues[BOTTOM_LEFT] == targetCardValues[TOP_LEFT] && topCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_RIGHT]) return true;
            return false;
        } else {
            console.log('isGuessCorrect, c4');
            // 2 cards
            uint leftCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2-1];
            // uint leftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint256[4] memory leftCardValues = numberToCard(leftCard);
            uint rightCard = board[guessCoordinates[ROW] / 2][guessCoordinates[COLUMN] / 2];
            // uint rightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory rightCardValues = numberToCard(rightCard);
            if (leftCardValues[BOTTOM_RIGHT] == targetCardValues[BOTTOM_LEFT] && rightCardValues[BOTTOM_LEFT] == targetCardValues[BOTTOM_RIGHT] && leftCardValues[TOP_RIGHT] == targetCardValues[TOP_LEFT] && rightCardValues[TOP_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (leftCardValues[BOTTOM_RIGHT] == targetCardValues[BOTTOM_LEFT] && rightCardValues[BOTTOM_LEFT] == targetCardValues[BOTTOM_RIGHT] && leftCardValues[TOP_RIGHT] == targetCardValues[TOP_LEFT] && rightCardValues[TOP_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (leftCardValues[BOTTOM_RIGHT] == targetCardValues[BOTTOM_LEFT] && rightCardValues[BOTTOM_LEFT] == targetCardValues[BOTTOM_RIGHT] && leftCardValues[TOP_RIGHT] == targetCardValues[TOP_LEFT] && rightCardValues[TOP_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            targetCard = rotateCard(targetCard);
            if (leftCardValues[BOTTOM_RIGHT] == targetCardValues[BOTTOM_LEFT] && rightCardValues[BOTTOM_LEFT] == targetCardValues[BOTTOM_RIGHT] && leftCardValues[TOP_RIGHT] == targetCardValues[TOP_LEFT] && rightCardValues[TOP_LEFT] == targetCardValues[TOP_RIGHT]) return true;
            return false;
        }
    }

    // Maps the 4 values of the card to a single number (0 to 255)
    function cardToNumber(uint256[4] memory cardValues) private pure returns (uint256) {
        require(cardValues.length == 4, "Card must have exactly 4 values.");
        uint256 result = 0;
        for (uint256 i = 0; i < 4; i++) {
            require(cardValues[i] < 4, "Each value must be between 0 and 3.");
            result += cardValues[i] * uint256(4**i);
        }
        return result;
    }

    // Maps a number (0 to 255) back to the 4 values of the card
    function numberToCard(uint256 number) private pure returns (uint256[4] memory) {
        require(number < 256, "Number must be between 0 and 255.");
        uint256[4] memory cardValues;
        for (uint256 i = 0; i < 4; i++) {
            cardValues[i] = number % 4;
            number /= 4;
            // 40 -> 0, 10 -> 2, 2->2, 0->0
        }
        return cardValues;
    }
    
    function generatePermutation(uint256 seed) public pure returns (uint256[BOARD_WIDTH][BOARD_WIDTH] memory board) {
        uint256[NUM_CARDS] memory permutation;
        for (uint256 i = 0; i < NUM_CARDS; i++) {
            permutation[i] = i;
        }
        for (uint256 i = NUM_CARDS - 1; i > 0; i--) {
            uint256 j = random(seed, i + 1);
            (permutation[i], permutation[j]) = (permutation[j], permutation[i]);
            seed = uint256(keccak256(abi.encodePacked(seed, i)));
        }
        for (uint256 i = 0; i < BOARD_WIDTH; i++) {
            for (uint256 j = 0; j < BOARD_WIDTH; j++) {
                board[i][j] = permutation[i*BOARD_WIDTH + j];
            }
        }
    }

    function random(uint256 seed, uint256 upperBound) private pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed))) % upperBound;
    }
}
