///|
test "panic new with negative integrater should panic" {
  let test0 = @immut_BitVector.new(-1)
  test0 |> ignore
}

///|
test "panic get with out of range index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.get(10) // 索引越界
  result |> ignore
}

///|
test "panic set with out of range index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.set(10) // 索引越界
  result |> ignore
}

///|
test "panic clear with out of range index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.clear(10) // 索引越界
  result |> ignore
}

///|
test "panic flip with out of range index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.flip(10) // 索引越界
  result |> ignore
}

///|
test "panic slice with invalid start index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.slice(-1, 5) // 起始索引无效
  result |> ignore
}

///|
test "panic slice with invalid end index should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.slice(0, 11) // 结束索引越界
  result |> ignore
}

///|
test "panic slice with start greater than end should panic" {
  let bv = @immut_BitVector.new(10)
  let result = bv.slice(5, 3) // 起始索引大于结束索引
  result |> ignore
}

///|
test "panic from_ints with mismatched length should panic" {
  let ints = FixedArray::from_array([3UL, 7UL])
  let result = @immut_BitVector.from_ints(ints, 300) // 位数不能匹配整数数组长度
  result |> ignore
} //

///|
test "panic and with different length should panic" {
  let bv1 = @immut_BitVector.new(10)
  let bv2 = @immut_BitVector.new(15)
  let result = bv1.and(bv2) // 不同长度的位向量
  result |> ignore
}

///|
test "panic or with different length should panic" {
  let bv1 = @immut_BitVector.new(10)
  let bv2 = @immut_BitVector.new(15)
  let result = bv1.or(bv2) // 不同长度的位向量
  result |> ignore
}

///|
test "panic xor with different length should panic" {
  let bv1 = @immut_BitVector.new(10)
  let bv2 = @immut_BitVector.new(15)
  let result = bv1.xor(bv2) // 不同长度的位向量
  result |> ignore
}

///|
test "panic from_string with invalid char should panic" {
  let result = @immut_BitVector.from_string("1010X") // 含有非0/1字符
  result |> ignore
}

///|
test "panic concat resulting in excessive length should panic" {
  let bv1 = @immut_BitVector.new(0x7FFFFFFF - 10) // 接近最大长度
  let bv2 = @immut_BitVector.new(20)
  let result = bv1.concat(bv2) // 可能导致长度溢出
  result |> ignore
}

///|
test "panic from_ints with non-positive length should panic" {
  let ints = FixedArray::from_array([3UL, 7UL])
  let result = @immut_BitVector.from_ints(ints, -1) // 使用负数长度
  result |> ignore
}

///|
test "panic from_ints with zero length should panic" {
  let ints = FixedArray::from_array([3UL, 7UL])
  let result = @immut_BitVector.from_ints(ints, 0) // 使用零长度
  result |> ignore
}
