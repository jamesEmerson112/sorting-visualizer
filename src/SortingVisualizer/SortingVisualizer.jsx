import React from "react";
import './SortingVisualizer.css';
import * as sortingAlgorithms from '../sortingAlgorithms/sortingAlgorithms.js';

// change the speed of the animations
const ANIMATION_SPEED_MS = 10;

// change the number of bars in the array.
const NUMBER_OF_ARRAY_BARS = 150;

// main color of the array bars
const PRIMARY_COLOR = 'turquoise';

// main color of array bars that are being compared throughout the animations.
const SECONDARY_COLOR = 'red';

export class SortingVisualizer extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            array: [],
        }
    }

    componentDidMount() {
        this.resetArray();
    }

    resetArray() {
        const array = [];
        // may replace this with something else to have the pyramid flatter
        for(let i = 0; i < NUMBER_OF_ARRAY_BARS; i++) {
            array.push(randomIntFromInterval(5, 500));          // using 5 because 1 is too small
        }
        this.setState({array});
    }

    mergeSort(){
        // console.log("merge sorting")
        // const javaScriptSortedArray = this.state.array.slice().sort((a,b) => a-b);          // apparently this is how sorting numbesr works in javascript
        // const sortedArray = sortingAlgorithms.mergeSort(this.state.array);
        // console.log(sortedArray);
        // console.log("Is the array sorted ? " + arraysAreEqual(javaScriptSortedArray, sortedArray));
        
        const animations = sortingAlgorithms.mergeSort(this.state.array);
        console.log("before gah bah goo")

        // animation
        // each i is an animation
        for(let i = 0; i < animations.length; i++) {
            const arrayBars = document.getElementsByClassName('array-bar');

            // is there more than 2 elements involved? Because there should not. i % 3 can equal to either 0, 1, 2
            const isColorChange = i % 3 !== 2
            if(isColorChange) {
                const [barOneIdx, barTwoIdx] = animations[i];
                const barOneStyle = arrayBars[barOneIdx].style;
                const barTwoStyle = arrayBars[barTwoIdx].style;
                const color = i % 3 ===0 ? SECONDARY_COLOR : PRIMARY_COLOR;
                setTimeout(() => {
                    // console.log(color);
                    barOneStyle.backgroundColor = color;
                    barTwoStyle.backgroundColor = color;
                }, i * ANIMATION_SPEED_MS)
            } else {
                setTimeout(() => {
                    const[barOneIdx, newHeight] = animations[i];
                    const barOneStyle = arrayBars[barOneIdx].style;
                    barOneStyle.height = `${newHeight}px`;
                }, i * ANIMATION_SPEED_MS);
            }
        }
    }
    insertSort(){}
    bubbleSort(){}
    quickSort(){}
    heapSort(){}
    testSortAlgorithms() {
        for(let i = 0; i < 100; i++) {
            const array = [];
            const length = randomIntFromInterval(1,1000);
            for(let i = 0; i < length;i++) {
                array.push(randomIntFromInterval(-1000, 1000))
            }
            const javaScriptSortedArray = this.state.array.slice().sort((a,b) => a-b);          // apparently this is how sorting numbesr works in javascript
            sortingAlgorithms.mergeSort(this.state.array);
            
            const sortedArray = this.state.array;
            
            console.log(arraysAreEqual(javaScriptSortedArray, sortedArray));            
        }
    }


    render() {
        const{array} = this.state;
        
        return (
            <div className="array-container">
            {array.map((value, idx) => (
                <div className="array-bar" key={idx}
                style={{height: `${value}px`}}>
                </div>
            ))}
            <br></br>
            <button onClick={() => this.resetArray()}>Generate New Array</button>
            <button onClick={() => this.testSortAlgorithms()}>Test sort algorithms</button>
            <button onClick={() => this.mergeSort()}>Merge Sort</button>
            <button onClick={() => this.insertionSort()}>Insertion Sort</button>
            <button onClick={() => this.bubbleSort()}>Bubble Sort</button>
            <button onClick={() => this.quickSort()}>Quick Sort</button>
            <button onClick={() => this.heapSort()}>Heap Sort</button>
            </div>
        )
    }
}

function randomIntFromInterval(min, max) {
    return Math.floor(Math.random() * (max-min +1) + min);
}

function arraysAreEqual(arrayOne, arrayTwo) {
    if(arrayOne.length !== arrayTwo.length) return false;

    for(let i = 0; i <= 0; ++i) {
        if(arrayOne[i] !== arrayTwo[i]) return false;
    }

    return true;
}