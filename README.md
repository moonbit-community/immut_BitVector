# immut_BitVector

[English](https://github.com/moonbit-community/immut_BitVector/blob/main/README.md) | [简体中文](https://github.com/moonbit-community/immut_BitVector/blob/main/README_zh_CN.md) 


[![Build Status](https://img.shields.io/github/actions/workflow/status/moonbit-community/immut_BitVector/ci.yml)](https://github.com/moonbit-community/Indeximmut_BitVector/actions)  [![codecov](https://codecov.io/gh/moonbit-community/immut_BitVector/branch/main/graph/badge.svg)](https://codecov.io/gh/moonbit-community/immut_BitVector)  


immut_BitVector is an efficient immutable bit vector data structure for compact and efficient storage and manipulation of boolean sequences. It provides a series of bit operations while maintaining immutability (all modification operations return new immut_BitVector instances).

## 🚀 Key Features
• 🔄 Multiple Construction Methods - Support for creating empty vectors, all-0 vectors, all-1 vectors, and creating from boolean arrays, integer arrays, or strings  
• ➕ Basic Bit Operations - Get, set, clear, and flip bits at specific positions  
• 🔀 Logical Operations - Support for bitwise AND, OR, XOR, and other operations  
• 🔢 Bit Counting and Finding - Count the number of 1s and 0s, find the first set bit  
• ✂️ Slicing and Concatenation - Extract sub-vectors and combine vectors  
• 📊 Serialization - Convert to string or boolean array  
• 🛠️ Utility Methods - Check if all bits are 0, all bits are 1, and other practical functions  

## 📥 Installation
```bash
moon add kesmeey/immut_BitVector
```

## 🚀 Usage Guide

### 🔨 Creating Bit Vectors
You can create bit vectors using the `new()`, `ones()`, `from_bools()`, `from_ints()`, or `from_string()` methods.

```moonbit
// Create a bit vector with all bits set to 0
let bv1 = @immut_BitVector.new(10)  // Length 10, all 0s

// Create a bit vector with all bits set to 1
let bv2 = @immut_BitVector.ones(10)  // Length 10, all 1s

// Create from boolean array
let bools = FixedArray::make(5, false)
bools[1] = true
bools[3] = true
let bv3 = @immut_BitVector.from_bools(bools)  // Results in "01010"

// Create from string
let bv4 = @immut_BitVector.from_string("10110")  // From binary string

// Create from integer array
let ints = FixedArray::make(2, 0UL)
ints[0] = 42UL  // Binary: ...0101010
let bv5 = @immut_BitVector.from_ints(ints, 128)  // 128-bit length vector
```

### ➕ Basic Bit Operations
Use the `get()`, `set()`, `clear()`, and `flip()` methods to manipulate bits at specific positions.

```moonbit
let bv = @immut_BitVector.new(10)  // Create all-0 bit vector

// Get bit value
let bit = bv.get(3)  // Get bit value at index 3, returns false

// Set bit (returns new bit vector)
let bv2 = bv.set(3)  // Set bit at index 3 to 1
assert_eq!(bv2.get(3), true)
assert_eq!(bv.get(3), false)  // Original vector unchanged

// Clear bit
let bv3 = bv2.clear(3)  // Clear bit at index 3 to 0
assert_eq!(bv3.get(3), false)

// Flip bit
let bv4 = bv.flip(5)  // Flip bit at index 5
assert_eq!(bv4.get(5), true)

// Flip all bits
let bv5 = bv.flip_all()  // Flip all bits
assert_eq!(bv5.get(0), true)
```

### 🔀 Logical Operations
Use the `and()`, `or()`, `xor()`, and `not()` methods for bitwise logical operations.

```moonbit
let bv1 = @immut_BitVector.from_string("1100")
let bv2 = @immut_BitVector.from_string("1010")

// Bitwise AND
let and_result = bv1.and(bv2)  // "1000"

// Bitwise OR
let or_result = bv1.or(bv2)  // "1110"

// Bitwise XOR
let xor_result = bv1.xor(bv2)  // "0110"

// Bitwise NOT (flip all bits)
let not_result = bv1.not()  // "0011"
```

### 🔢 Bit Counting and Finding
Use the `count_ones()`, `count_zeros()`, and `find_first_set()` methods to count and find bits.

```moonbit
let bv = @immut_BitVector.from_string("101100")

// Count the number of 1s
let ones = bv.count_ones()  // 3

// Count the number of 0s
let zeros = bv.count_zeros()  // 3

// Find the position of the first bit set to 1
let first_set = bv.find_first_set()  // 0 (zero-based index)
```

### ✂️ Slicing and Concatenation
Use the `slice()` and `concat()` methods to extract sub-vectors and combine vectors.

```moonbit
let bv = @immut_BitVector.from_string("1011001010")

// Slice (inclusive start, exclusive end)
let slice = bv.slice(2, 6)  // "1100"

// Concatenate two bit vectors
let bv2 = @immut_BitVector.from_string("0101")
let concat_result = bv.concat(bv2)  // "10110010100101"
```

### 📊 Serialization
Use the `to_string()` and `to_bools()` methods to convert bit vectors to other formats.

```moonbit
let bv = @immut_BitVector.from_string("10110")

// Convert to string
let str = bv.to_string()  // "10110"

// Convert to boolean array
let bools = bv.to_bools()  // [true, false, true, true, false]
```

### 🛠️ Utility Methods
Use the `is_all_zeros()`, `is_all_ones()`, and `length()` methods to get the status of bit vectors.

```moonbit
let bv1 = @immut_BitVector.new(10)  // All-0 bit vector
let bv2 = @immut_BitVector.ones(10)  // All-1 bit vector

// Check if all bits are 0
assert_true!(bv1.is_all_zeros())
assert_false!(bv2.is_all_zeros())

// Check if all bits are 1
assert_true!(bv2.is_all_ones())
assert_false!(bv1.is_all_ones())

// Get length
assert_eq!(bv1.length(), 10)

// Create bit masks
let mask = @immut_BitVector.bit_mask(3)  // Create mask at position 3 (...0001000)
let low_mask = @immut_BitVector.low_bits_mask(3)  // Create mask from 0 to position 3 (...0001111)
```

## 🚀 Advanced Usage Examples

### Example: Implementing Simple Sets with BitVector

```moonbit
// Use BitVector to represent sets containing elements 0-9
let set_a = @immut_BitVector.from_string("1010100101")  // Contains elements 0,2,4,7,9
let set_b = @immut_BitVector.from_string("1100011001")  // Contains elements 0,3,4,5,8,9

// Set operations
let union = set_a.or(set_b)         // Union
let intersection = set_a.and(set_b)  // Intersection
let difference = set_a.xor(set_b)    // Symmetric difference

// Print results
println("Set A: " + set_a.to_string())      // 1010100101
println("Set B: " + set_b.to_string())      // 1100011001
println("Union: " + union.to_string())       // 1110111101
println("Intersection: " + intersection.to_string()) // 1000000001
println("Symmetric Difference: " + difference.to_string()) // 0110111100
```

### Example: Efficient Bit Operations with BitVector

```moonbit
// Create a 128-bit vector for bit field operations
let flags = @immut_BitVector.new(128)

// Set different flag bits
let flags = flags.set(5).set(10).set(42).set(100)

// Check flag bits
if flags.get(10) {
  println("Flag 10 is set")
}

// Use masks for batch operations
let mask = @immut_BitVector.from_string("00111100")  // Bit mask
let masked = flags.slice(0, 8).and(mask)  // Apply mask to first 8 bits

println("After applying mask: " + masked.to_string())
```

## 📜 License
This project is licensed under the Apache-2.0 License. See LICENSE file for details.

## 📢 Contact & Support
• Moonbit Community: moonbit-community  
• GitHub Issues: [Report an Issue](https://github.com/kesmeey/immut_BitVector/issues)

👋 If you like this project, give it a ⭐! Happy coding! 🚀
