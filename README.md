# Bomberman With MIPS Assembly

## Introduction
This project involves the implementation of a simplified version of the famous Bomberman game on the MIPS architecture. The goal is to create a primitive simulation of Bomberman with different versions, each with varying complexities.

## Versions

### Version 1
- Matrix size is fixed at 16x16.
- Simulation ends after 3 seconds.
- Maximum grade: 85pts.

### Version 2
- Matrix size is dynamic based on user input.
- Simulation ends after 3 seconds.
- Maximum grade: 100pts.

### Version 3
- Same as the implementation in the provided link.
- Everything, including the number of seconds, is taken from the user.
- Maximum grade: 115pts.

### Version 4
- Detect if there is an open path from [0, 0] to [max_i, max_j] during a simulation instance.
- A path is open if one can pass from one matrix position to another without stepping over a bomb.
- Maximum grade: 130pts.

## Rules

- Use MARS ISS for development.
- Pseudo instructions are allowed.
- Comment each line of your assembly to explain the purpose.
- Implement at least 3 assembly subroutines wisely.
- Prioritize a working lower version over a non-working higher version.
- Start with Version 1 and update to subsequent versions.
- Obey the contract and avoid plagiarism.
- Implement the solution in C first, then replicate the algorithm in assembly.

## Aims

- Gain proficiency in assembly for generic programming.
- Understand how simple instructions can solve generic problems.
- Think similarly to the MIPS CPU.
- Gain insights into compiler workings.

## Notes

To run this project you must have the asm simulator called MARS. To access it, you can visit: 
![MARS MIPS] (https://courses.missouristate.edu/kenvollmar/mars/)