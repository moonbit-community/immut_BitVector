///|
pub(all) struct BitVector {
  /// Underlying array storing bit data, each UInt64 stores 64 bits
  data : FixedArray[UInt64]

  /// Total number of bits in the vector
  length : Int

  /// Optimization constant, recording the number of valid bits in the last UInt64
  last_mask : UInt64
} derive(Eq, Show) ///|
