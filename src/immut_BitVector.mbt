///|
/// BitVector is an immutable bit vector data structure for compact and efficient storage and manipulation of boolean sequences.
/// It provides a series of bit operations while maintaining immutability (all modification operations return new BitVector instances).

///|
pub const UINT64_MAX = 0xffffffffffffffffUL

///|
/// Creates a bit vector of specified length with all bits set to 0
pub fn new(length : Int) -> BitVector {
  if length < 0 {
    abort("BitVector length must be positive")
  }

  // Calculate how many UInt64s are needed to store bits of specified length
  let num_ints = (length + 63) >> 6
  let data = FixedArray::make(num_ints, 0UL)

  // Calculate the valid bit mask for the last UInt64
  let remainder = length & 63 // equivalent to length % 64
  let last_mask = if remainder == 0 {
    UINT64_MAX
  } else {
    (1UL << remainder) - 1UL
  }
  { data, length, last_mask }
}

///|
/// Creates a bit vector of specified length with all bits set to 1
pub fn ones(length : Int) -> BitVector {
  let bv = new(length)

  // Fill all UInt64s with 1s
  for i = 0; i < bv.data.length(); i = i + 1 {
    bv.data[i] = UINT64_MAX
  }

  // Set the last UInt64, only setting valid bits to 1
  if bv.data.length() > 0 {
    bv.data[bv.data.length() - 1] = UINT64_MAX & bv.last_mask
  }
  bv
}

///|
/// Creates a bit vector from an array of integers
pub fn from_ints(ints : FixedArray[UInt64], length : Int) -> BitVector {
  if length <= 0 {
    abort("BitVector length must be positive")
  }
  let num_ints = (length + 63) >> 6
  if ints.length() < num_ints {
    abort("Array too small for specified length")
  }

  // Calculate the valid bit mask for the last UInt64
  let remainder = length & 63
  let last_mask = if remainder == 0 {
    UINT64_MAX
  } else {
    (1UL << remainder) - 1UL
  }

  // Copy array and clear invalid bits in the last UInt64
  let data = ints.copy()
  if data.length() > 0 && remainder != 0 {
    data[data.length() - 1] = data[data.length() - 1] & last_mask
  }
  { data, length, last_mask }
}

///|
/// Creates a bit vector from an array of booleans
pub fn from_bools(bools : FixedArray[Bool]) -> BitVector {
  let length = bools.length()
  let bv = new(length)

  // Set each bit
  for i in 0..<length {
    if bools[i] {
      let word_idx = i >> 6 // divide by 64
      let bit_idx = i & 63 // modulo 64
      bv.data[word_idx] = bv.data[word_idx] | (1UL << bit_idx)
    }
  }
  bv
}

///|
/// Creates a bit vector from a string ("1" for set bits, "0" for clear bits)
pub fn from_string(s : String) -> BitVector {
  let length = s.length()
  let bv = new(length)
  for i in 0..<length {
    if s[i] == '1' {
      let word_idx = i >> 6
      let bit_idx = i & 63
      bv.data[word_idx] = bv.data[word_idx] | (1UL << bit_idx)
    } else if s[i] != '0' {
      abort("String must contain only '0' and '1' characters")
    }
  }
  bv
}
//-----------------------------------------------------------------------------
// Basic Bit Operations
//-----------------------------------------------------------------------------

///|
/// Gets the boolean value at the specified position in the bit vector
pub fn get(self : BitVector, index : Int) -> Bool {
  if index < 0 || index >= self.length {
    abort("Index out of bounds")
  }
  let word_idx = index >> 6
  let bit_idx = index & 63
  (self.data[word_idx] & (1UL << bit_idx)) != 0
}

///|
/// Sets the bit at the specified position to 1, returns a new bit vector
pub fn set(self : BitVector, index : Int) -> BitVector {
  if index < 0 || index >= self.length {
    abort("Index out of bounds")
  }
  let word_idx = index >> 6
  let bit_idx = index & 63

  // If the bit is already 1, return the original bit vector
  if (self.data[word_idx] & (1UL << bit_idx)) != 0 {
    return self
  }

  // Create a new bit vector
  let new_data = self.data.copy()
  new_data[word_idx] = new_data[word_idx] | (1UL << bit_idx)
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

///|
/// Clears the bit at the specified position to 0, returns a new bit vector
pub fn clear(self : BitVector, index : Int) -> BitVector {
  if index < 0 || index >= self.length {
    abort("Index out of bounds")
  }
  let word_idx = index >> 6
  let bit_idx = index & 63

  // If the bit is already 0, return the original bit vector
  if (self.data[word_idx] & (1UL << bit_idx)) == 0 {
    return self
  }

  // Create a new bit vector
  let new_data = self.data.copy()
  new_data[word_idx] = new_data[word_idx] & (UINT64_MAX ^ (1UL << bit_idx))
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

///|
/// Flips the value of the bit at the specified position, returns a new bit vector
pub fn flip(self : BitVector, index : Int) -> BitVector {
  if index < 0 || index >= self.length {
    abort("Index out of bounds")
  }
  let word_idx = index >> 6
  let bit_idx = index & 63

  // Create a new bit vector
  let new_data = self.data.copy()
  new_data[word_idx] = new_data[word_idx] ^ (1UL << bit_idx)
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

///|
/// Flips all bits in the vector, returns a new bit vector
pub fn flip_all(self : BitVector) -> BitVector {
  let new_data = self.data.copy()

  // Flip all integers
  for i in 0..<new_data.length() {
    new_data[i] = new_data[i] ^ UINT64_MAX
  }

  // Ensure invalid bits in the last integer are 0
  if (self.length & 63) != 0 && new_data.length() > 0 {
    new_data[new_data.length() - 1] = new_data[new_data.length() - 1] &
      self.last_mask
  }
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

//-----------------------------------------------------------------------------
// Logical Operations
//-----------------------------------------------------------------------------

///|
/// Performs bitwise AND operation on bit vectors, returns a new bit vector
pub fn and(self : BitVector, other : BitVector) -> BitVector {
  if self.length != other.length {
    abort("BitVectors must have the same length for logical operations")
  }
  let new_data = FixedArray::make(self.data.length(), 0UL)

  // Perform bitwise AND operation
  for i in 0..<new_data.length() {
    new_data[i] = self.data[i] & other.data[i]
  }
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

///|
/// Performs bitwise OR operation on bit vectors, returns a new bit vector
pub fn or(self : BitVector, other : BitVector) -> BitVector {
  if self.length != other.length {
    abort("BitVectors must have the same length for logical operations")
  }
  let new_data = FixedArray::make(self.data.length(), 0UL)

  // Perform bitwise OR operation
  for i in 0..<new_data.length() {
    new_data[i] = self.data[i] | other.data[i]
  }
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

///|
/// Performs bitwise XOR operation on bit vectors, returns a new bit vector
pub fn xor(self : BitVector, other : BitVector) -> BitVector {
  if self.length != other.length {
    abort("BitVectors must have the same length for logical operations")
  }
  let new_data = FixedArray::make(self.data.length(), 0UL)

  // Perform bitwise XOR operation
  for i in 0..<new_data.length() {
    new_data[i] = self.data[i] ^ other.data[i]
  }
  { data: new_data, length: self.length, last_mask: self.last_mask }
}

//-----------------------------------------------------------------------------
// Bit Counting and Finding
//-----------------------------------------------------------------------------

///|
/// Counts the number of 1s in the bit vector
pub fn count_ones(self : BitVector) -> Int {
  let mut count = 0

  // Process all integers except the last one
  for i in 0..<(self.data.length() - 1) {
    count += pop_count(self.data[i])
  }

  // Process the last integer, only count valid bits
  if self.data.length() > 0 {
    let last = self.data[self.data.length() - 1] & self.last_mask
    count += pop_count(last)
  }
  count
}

///|
/// Counts the number of 0s in the bit vector
pub fn count_zeros(self : BitVector) -> Int {
  self.length - self.count_ones()
}

///|
/// Helper function: Count the number of 1s in an integer
fn pop_count(x : UInt64) -> Int {
  let mut x = x
  let mut count = 0
  while x != 0 {
    count += (x & 1).to_int()
    x = x >> 1
  }
  count
}

///|
/// Finds the index of the first bit set to 1 in the vector, returns -1 if none
pub fn find_first_set(self : BitVector) -> Int {
  for i in 0..<self.data.length() {
    if self.data[i] != 0 {
      let word = self.data[i]
      let bit_pos = lowest_set_bit(word)
      return (i << 6) + bit_pos
    }
  }
  -1
}

///|
/// Finds the index of the first bit set to 0 in the integer, returns -1 if none
pub fn lowest_unset_bit(x : UInt64) -> Int {
  if x == UINT64_MAX {
    return 64 // indicates no 0 bits
  }
  let mut pos = 0
  let mut val = x
  while (val & 1) == 1 {
    pos += 1
    val = val >> 1
  }
  pos
}

///|
/// Helper function: Find the position of the lowest 1 bit in an integer
pub fn lowest_set_bit(x : UInt64) -> Int {
  if x == 0 {
    return -1
  }
  let mut pos = 0
  let mut val = x
  while (val & 1) == 0 {
    pos += 1
    val = val >> 1
  }
  pos
}

//-----------------------------------------------------------------------------
// Slicing and Concatenation
//-----------------------------------------------------------------------------

///|
/// Extracts a sub-vector from the bit vector, starting at start (inclusive) and ending at end (exclusive)
pub fn slice(self : BitVector, start : Int, end : Int) -> BitVector {
  if start < 0 || end > self.length || start > end {
    abort("Invalid slice range")
  }
  let length = end - start
  let result = new(length)

  // 如果切片长度为0，返回空位向量
  if length == 0 {
    return result
  }

  // 计算起始和结束位置的字和位偏移
  let start_word = start >> 6
  let start_bit = start & 63
  let end_word = (end - 1) >> 6
  let end_bit = (end - 1) & 63

  // 处理切片在单个字内的情况
  if start_word == end_word {
    let mask = ((1UL << (end_bit - start_bit + 1)) - 1) << start_bit
    let bits = (self.data[start_word] & mask) >> start_bit
    result.data[0] = bits
    return result
  }

  // 处理切片跨越多个字的情况
  if start_bit == 0 {
    // 起始位在字边界上，可以直接复制完整字
    for i in start_word..=end_word {
      if i == end_word {
        // 最后一个字需要掩码处理
        result.data[i - start_word] = self.data[i] & low_bits_mask(end_bit + 1)
      } else {
        result.data[i - start_word] = self.data[i]
      }
    }
  } else {
    // 起始位不在字边界上
    let mut dst_idx = 0

    // 处理第一个字（部分）
    let first_word_bits = self.data[start_word] >> start_bit
    result.data[dst_idx] = first_word_bits

    // 处理中间的完整字和最后一个字

    // 处理中间的完整字和最后一个字
    for src_idx in (start_word + 1)..=end_word {
      // 高位部分来自上一个字
      let high_bits = self.data[src_idx - 1] << (64 - start_bit)

      // 低位部分来自当前字
      let low_bits = if src_idx == end_word {
        // 最后一个字需要掩码处理
        self.data[src_idx] & low_bits_mask(end_bit + 1)
      } else {
        self.data[src_idx]
      }

      // 关键修改：处理当前字的低位到前一个结果字的高位
      result.data[dst_idx] = result.data[dst_idx] |
        high_bits |
        (low_bits << (64 - start_bit))

      // 当前字的高位去下一个结果字（如果有）
      if dst_idx + 1 < result.data.length() {
        result.data[dst_idx + 1] = low_bits >> start_bit
      }
      dst_idx += 1
    }
  }
  return result
}

///|
/// Concatenates two bit vectors, returns a new bit vector
pub fn concat(self : BitVector, other : BitVector) -> BitVector {
  let new_length = self.length + other.length
  let result = new(new_length)

  // Copy the first bit vector
  for i in 0..<self.data.length() {
    result.data[i] = self.data[i]
  }

  // Calculate bits used in the last word of the first vector
  let offset = self.length & 63
  if offset == 0 {
    // Aligned case: first vector length is a multiple of 64
    for i in 0..<other.data.length() {
      result.data[self.data.length() + i] = other.data[i]
    }
  } else {
    // Need to handle bit offsets
    let boundary = self.data.length() - 1

    // Second vector's bits need to be distributed across two words
    for i in 0..<other.data.length() {
      // Low bits go into high bits of the current word
      result.data[boundary + i] = result.data[boundary + i] |
        (other.data[i] << offset)

      // High bits go into low bits of the next word
      if boundary + i + 1 < result.data.length() {
        result.data[boundary + i + 1] = result.data[boundary + i + 1] |
          (other.data[i] >> (64 - offset))
      }
    }
  }

  // Ensure invalid bits in the last word are 0
  if result.data.length() > 0 {
    let last_idx = result.data.length() - 1
    result.data[last_idx] = result.data[last_idx] & result.last_mask
  }
  return result
}
//-----------------------------------------------------------------------------
// Serialization
//-----------------------------------------------------------------------------

///|
/// Converts the bit vector to a string representation, 1 for set bits, 0 for clear bits
pub fn to_string(self : BitVector) -> String {
  let mut result = ""
  for i in 0..<self.length {
    if self.get(i) {
      result = result + "1"
    } else {
      result = result + "0"
    }
  }
  result
}

///|
/// Converts the bit vector to an array of booleans
pub fn to_bools(self : BitVector) -> FixedArray[Bool] {
  let result = FixedArray::make(self.length, false)
  for i in 0..<self.length {
    if self.get(i) {
      result[i] = true
    }
  }
  result
}

//-----------------------------------------------------------------------------
// Utility Methods
//-----------------------------------------------------------------------------

///|
/// Checks if the bit vector is all zeros
pub fn is_all_zeros(self : BitVector) -> Bool {
  for i = 0; i < self.data.length() - 1; i = i + 1 {
    if self.data[i] != 0 {
      return false
    }
  }

  // Check the last integer
  if self.data.length() > 0 {
    return (self.data[self.data.length() - 1] & self.last_mask) == 0
  }
  true
}

///|
/// Checks if the bit vector is all ones
pub fn is_all_ones(self : BitVector) -> Bool {
  for i = 0; i < self.data.length() - 1; i = i + 1 {
    if self.data[i] != UINT64_MAX {
      return false
    }
  }

  // Check the last integer
  if self.data.length() > 0 {
    return (self.data[self.data.length() - 1] & self.last_mask) ==
      self.last_mask
  }
  true
}

///|
/// Gets the length of the bit vector
pub fn length(self : BitVector) -> Int {
  self.length
}

///|
pub fn not(self : BitVector) -> BitVector {
  self.flip_all()
}

///| Creates a bit mask at the specified position (that bit is 1, others are 0)
pub fn bit_mask(bit_pos : Int) -> UInt64 {
  1UL << bit_pos
}

///| Creates a mask from 0 to the specified position (those bits are 1)
pub fn low_bits_mask(pos : Int) -> UInt64 {
  if pos >= 63 {
    return UINT64_MAX
  }
  (1UL << (pos + 1)) - 1
}
