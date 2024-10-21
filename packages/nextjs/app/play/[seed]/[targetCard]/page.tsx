"use client";

import { useParams } from 'next/navigation';
import { useScaffoldReadContract, useScaffoldWriteContract } from '~~/hooks/scaffold-eth';
import { useEffect, useState } from 'react';
import Card from '../../../../components/Card'; // Adjust path to Card component
import { useAccount } from "wagmi";


const PlayRoute = () => {
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  const params = useParams();

  // Extract seed and targetCard from the URL parameters
  const seedString = Array.isArray(params.seed) ? params.seed[0] : params.seed;
  const targetCardString = Array.isArray(params.targetCard) ? params.targetCard[0] : params.targetCard;

  const seedNumber = seedString ? BigInt(seedString) : undefined;
  const targetCardNumber = targetCardString ? BigInt(targetCardString) : undefined;

  const { data: boardData, isLoading } = useScaffoldReadContract({
    contractName: "QuestionMarkGame",
    functionName: "generatePermutation",
    args: [seedNumber],
  });

  const { writeContractAsync: guessAsync } = useScaffoldWriteContract("QuestionMarkGame");
  const { writeContractAsync: claimWinAsync } = useScaffoldWriteContract("QuestionMarkGame");

  const { address: connectedAddress } = useAccount();

  const { data: numCorrect } = useScaffoldReadContract({
    contractName: "QuestionMarkGame",
    functionName: "viewNumCorrectPerBoardPerPlayer",
    args: [seedNumber, connectedAddress],
  });

  const { data: winnerAddress } = useScaffoldReadContract({
    contractName: "QuestionMarkGame",
    functionName: "winnerPerBoard",
    args: [seedNumber],
  });
  console.log('winnerAddress', winnerAddress);

  const { data: maxNumCorrectPerBoard } = useScaffoldReadContract({
    contractName: "QuestionMarkGame",
    functionName: "maxNumCorrectPerBoard",
    args: [seedNumber],
  });
  console.log('maxNumCorrectPerBoard', maxNumCorrectPerBoard);
  const musicFilePath = maxNumCorrectPerBoard?.valueOf() < 9 ? "/music/theme song.mp3" : "/music/opium.mp3";

  const [processedBoard, setProcessedBoard] = useState<number[][][]>([]);
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [closestButton, setClosestButton] = useState<number | null>(null);

  useEffect(() => {
    if (boardData && !isLoading) {
      const board = boardData as unknown as readonly bigint[][];
      const processed = board.map((row) =>
        row.map((cardNumber) => convertToBase4(Number(cardNumber)))
      );
      setProcessedBoard(processed);
    }
  }, [boardData, isLoading]);

  const convertToBase4 = (num: number): number[] => {
    const digits = [];
    for (let i = 3; i >= 0; i--) {
      const divisor = Math.pow(4, i);
      const digit = Math.floor(num / divisor);
      digits.push(digit);
      num %= divisor;
    }
    return digits;
  };

  // Track mouse position
  const handleMouseMove = (event: React.MouseEvent<HTMLDivElement>) => {
    setMousePosition({ x: event.clientX, y: event.clientY });
    calculateClosestButton(event.clientX, event.clientY);
  };

  // Function to calculate which button is closest to the mouse
  const calculateClosestButton = (mouseX: number, mouseY: number) => {
    const buttonPositions = getButtonPositions(); // Get the button positions dynamically
    let closestIdx = null;
    let minDistance = Infinity;
    // console.log('mouseX,mouseY', mouseX, mouseY);
    buttonPositions.forEach((pos, idx) => {
      const distance = Math.sqrt(
        Math.pow(mouseX - pos.x, 2) + Math.pow(mouseY - pos.y, 2)
      );
      // console.log('distance', pos, idx, distance);
      if (distance < minDistance) {
        minDistance = distance;
        closestIdx = idx;
      }
    });

    setClosestButton(closestIdx);
  };

  const mapButtonIndexToCoordinates = (buttonIndex: number) => {
    // Implement logic to map buttonIndex to (x, y) coordinates
    // Return an array [x, y]

    // Example implementation:
    console.log('mapButtonIndexToCoordinates, buttonIndex', buttonIndex);
    const numCols = processedBoard[0].length;
    console.log('mapButtonIndexToCoordinates, numCols', numCols);
    const x = buttonIndex % (2 * numCols - 1) + 1;
    console.log('mapButtonIndexToCoordinates, x', x);
    const y = Math.floor(buttonIndex / (2 * numCols - 1)) + 1;
    console.log('mapButtonIndexToCoordinates, y', y);

    // Adjust y-coordinate to match bottom-left origin
    // const adjustedY = processedBoard.length - 1 - y;

    return [x, y];
  };

  const handleButtonClick = async (buttonIndex: number) => {
    if (!seedNumber || !targetCardNumber) {
      console.error("Seed or targetCard is missing.");
      return;
    }

    const [x, y] = mapButtonIndexToCoordinates(buttonIndex);
    const guessCoordinates: [bigint, bigint] = [BigInt(x), BigInt(y)];

    try {
      const result = await guessAsync({
        functionName: "guess",
        args: [seedNumber, targetCardNumber, guessCoordinates],
      });

      console.log("Guess submitted:", { seedNumber, targetCardNumber, guessCoordinates, result });
    } catch (error) {
      console.error("Error submitting guess:", error);
    }
  };

  const handleClaimWin = async () => {
    try {
      if (seedNumber) {
        const result = await claimWinAsync({
          functionName: "claimWin",
          args: [seedNumber],
        });
        console.log("claimWin: ", result);
      } else {
        console.error("Seed is missing.");
      }
    } catch (error) {
      console.error("Error claiming win:", error);
    }
  };


  const getButtonPositions = () => {
    // Calculate button positions based on the grid and return an array of positions
    // const positions = [];
    const positions: { x: number; y: number }[] = [];
    const gridSize = 100; // Assuming each card is 100px x 100px

    processedBoard.forEach((row, rowIndex) => {

      if (rowIndex == 0) {
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          }
        });
      } else {
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
            );
          }
        });
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          }
        });
      }
    });

    // console.log('positions', positions);

    return positions;
  };

  if (isLoading || !processedBoard.length) {
    return <p>Loading board...</p>;
  }

  return (
    <div onMouseMove={handleMouseMove} className="board-container">
      <div className="board">
        {processedBoard.map((row, rowIndex) => (
          <div className="board-row" key={rowIndex}>
            {row.map((cardDigits, colIndex) => (
              <Card key={`${rowIndex}-${colIndex}`} digits={cardDigits} />
            ))}
          </div>
        ))}
      </div>
      <div className="buttons-layer">
        {getButtonPositions().map((pos, idx) => (
          <button
            key={idx}
            className={`circle-button ${idx === closestButton ? 'visible' : 'hidden'}`}
            style={{ left: pos.x, top: pos.y }}
            onClick={() => handleButtonClick(idx)}
          />
        ))}
      </div>
      <div className="right-panel flex flex-col items-center space-y-4">
        {/* <h2>Target Card</h2> */}
        <h2></h2>
        <div className="mt-20"></div> {/* Gap between board and targetCardNumber */}

        <Card digits={convertToBase4(Number(targetCardNumber))} />

        <div className="flex flex-col items-center space-y-2">
          <img src="/images/points.png" alt="Points" className="w-24 h-24" />
          <p className="text-lg font-semibold">
            {numCorrect !== undefined ? numCorrect.toString() : "..."}
          </p>
        </div>

        <div className="flex flex-col items-center space-y-2">
          <img src="/images/winner.png" alt="Winner" className="w-24 h-24" onClick={handleClaimWin} />
          <p className="text-lg font-semibold">
            {winnerAddress && winnerAddress !== zeroAddress
              ? `${winnerAddress}`
              : "..."}
          </p>
        </div>

        <audio autoPlay controls loop className="mt-4">
          <source src={musicFilePath} type="audio/mpeg" />
          Your browser does not support the audio element.
        </audio>
      </div>
    </div>
  );
};

export default PlayRoute;
