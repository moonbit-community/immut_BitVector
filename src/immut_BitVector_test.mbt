// 构造函数测试
///|
test "new_constructor" {
  let bv = @immut_BitVector.new(64)
  assert_eq!(bv.length(), 64)
  assert_eq!(bv.is_all_zeros(), true)
  assert_eq!(bv.is_all_ones(), false)
  assert_eq!(bv.count_ones(), 0)
}

///|
test "ones_constructor" {
  let bv = @immut_BitVector.ones(64)
  assert_eq!(bv.length(), 64)
  assert_eq!(bv.is_all_ones(), true)
  assert_eq!(bv.is_all_zeros(), false)
  assert_eq!(bv.count_zeros(), 0)
}

///|
test "from_ints_constructor" {
  let ints = FixedArray::from_array([3UL, 7UL]) // 二进制: 11 and 111
  let bv = @immut_BitVector.from_ints(ints, 128)
  assert_eq!(bv.get(0), true)
  assert_eq!(bv.get(1), true)
  assert_eq!(bv.get(2), false)
  assert_eq!(bv.get(64), true)
  assert_eq!(bv.get(65), true)
  assert_eq!(bv.get(66), true)
}

///|
test "from_bools_constructor" {
  let bools = FixedArray::from_array([true, false, true, true])
  let bv = @immut_BitVector.from_bools(bools)
  assert_eq!(bv.length(), 4)
  assert_eq!(bv.get(0), true)
  assert_eq!(bv.get(1), false)
  assert_eq!(bv.get(2), true)
  assert_eq!(bv.get(3), true)
}

///|
test "from_string_constructor" {
  let bv = @immut_BitVector.from_string("1010")
  assert_eq!(bv.length(), 4)
  assert_eq!(bv.get(0), true)
  assert_eq!(bv.get(1), false)
  assert_eq!(bv.get(2), true)
  assert_eq!(bv.get(3), false)
}

// 基本位操作测试
///|
test "get_operation" {
  let bv = @immut_BitVector.from_string("10101")
  assert_eq!(bv.get(0), true)
  assert_eq!(bv.get(1), false)
  assert_eq!(bv.get(4), true)
}

///|
test "set_operation" {
  let bv = @immut_BitVector.new(5)
  let bv2 = bv.set(2)
  assert_eq!(bv.get(2), false) // 原始位向量保持不变
  assert_eq!(bv2.get(2), true) // 新位向量已修改

  // 设置已经为1的位应该返回相同位向量
  let bv3 = bv2.set(2)
  assert_eq!(bv3.get(2), true)
}

///|
test "clear_operation" {
  let bv = @immut_BitVector.ones(5)
  let bv2 = bv.clear(2)
  assert_eq!(bv.get(2), true) // 原始位向量保持不变
  assert_eq!(bv2.get(2), false) // 新位向量已修改

  // 清除已经为0的位应该返回相同位向量
  let bv3 = bv2.clear(2)
  assert_eq!(bv3.get(2), false)
}

///|
test "flip_operation" {
  let bv = @immut_BitVector.from_string("10101")
  let bv2 = bv.flip(1)
  assert_eq!(bv.get(1), false) // 原始位向量保持不变
  assert_eq!(bv2.get(1), true) // 新位向量已修改
  let bv3 = bv2.flip(0)
  assert_eq!(bv3.get(0), false) // 翻转原来的1
}

///|
test "flip_all_operation" {
  let bv = @immut_BitVector.from_string("10101")
  let bv2 = bv.flip_all()
  assert_eq!(bv2.get(0), false)
  assert_eq!(bv2.get(1), true)
  assert_eq!(bv2.get(2), false)
  assert_eq!(bv2.get(3), true)
  assert_eq!(bv2.get(4), false)
}

// 逻辑运算测试
///|
test "and_operation" {
  let bv1 = @immut_BitVector.from_string("1010")
  let bv2 = @immut_BitVector.from_string("1100")
  let result = bv1.and(bv2)
  assert_eq!(result.to_string(), "1000")
}

///|
test "or_operation" {
  let bv1 = @immut_BitVector.from_string("1010")
  let bv2 = @immut_BitVector.from_string("1100")
  let result = bv1.or(bv2)
  assert_eq!(result.to_string(), "1110")
}

///|
test "xor_operation" {
  let bv1 = @immut_BitVector.from_string("1010")
  let bv2 = @immut_BitVector.from_string("1100")
  let result = bv1.xor(bv2)
  assert_eq!(result.to_string(), "0110")
}

// 位计数和查找测试
///|
test "count_ones" {
  let bv = @immut_BitVector.from_string("101010")
  assert_eq!(bv.count_ones(), 3)
}

///|
test "count_zeros" {
  let bv = @immut_BitVector.from_string("101010")
  assert_eq!(bv.count_zeros(), 3)
}

///|
test "find_first_set" {
  let bv1 = @immut_BitVector.from_string("001010")
  assert_eq!(bv1.find_first_set(), 2)
  let bv2 = @immut_BitVector.new(5) // 全0
  assert_eq!(bv2.find_first_set(), -1)
}

// 截取和拼接测试
///|
test "slice_operation" {
  let bv = @immut_BitVector.from_string("101010")
  let slice = bv.slice(1, 4)
  assert_eq!(slice.length(), 3)
  assert_eq!(slice.to_string(), "010")
}

///|
test "concat_operation" {
  let bv1 = @immut_BitVector.from_string("101")
  let bv2 = @immut_BitVector.from_string("010")
  let result = bv1.concat(bv2)
  assert_eq!(result.length(), 6)
  assert_eq!(result.to_string(), "101010")
}

// 序列化测试
///|
test "to_string_operation" {
  let bv = @immut_BitVector.from_string("101010")
  assert_eq!(bv.to_string(), "101010")
}

///|
test "to_bools_operation" {
  let bv = @immut_BitVector.from_string("1010")
  let bools = bv.to_bools()
  assert_eq!(bools.length(), 4)
  assert_eq!(bools[0], true)
  assert_eq!(bools[1], false)
  assert_eq!(bools[2], true)
  assert_eq!(bools[3], false)
}

// 实用方法测试
///|
test "is_all_zeros" {
  let bv1 = @immut_BitVector.new(100)
  assert_eq!(bv1.is_all_zeros(), true)
  let bv2 = @immut_BitVector.from_string("0000100000")
  assert_eq!(bv2.is_all_zeros(), false)
}

///|
test "is_all_ones" {
  let bv1 = @immut_BitVector.ones(100)
  assert_eq!(bv1.is_all_ones(), true)
  let bv2 = @immut_BitVector.from_string("1111011111")
  assert_eq!(bv2.is_all_ones(), false)
}

// 边界情况测试
///|
test "boundary_cases" {
  // 测试跨越多个整数的位向量
  let bv = @immut_BitVector.new(100)
  let bv2 = bv.set(63) // 第一个整数的最后一位
  let bv3 = bv2.set(64) // 第二个整数的第一位
  assert_eq!(bv3.get(63), true)
  assert_eq!(bv3.get(64), true)

  // 测试最后一个整数的掩码
  let bv4 = @immut_BitVector.ones(65) // 刚好超出一个整数
  assert_eq!(bv4.get(64), true)
  assert_eq!(bv4.length(), 65)
  assert_eq!(bv4.count_ones(), 65)
}

// 按位取反操作测试
///|
test "not_operation" {
  let bv = @immut_BitVector.from_string("10101")
  let result = bv.not()
  assert_eq!(result.to_string(), "01010")
}

///|
test "bit_mask_function" {
  // 测试位掩码辅助函数
  let mask0 = @immut_BitVector.bit_mask(0)
  assert_eq!(mask0, 1UL)
  let mask5 = @immut_BitVector.bit_mask(5)
  assert_eq!(mask5, 1UL << 5)
  let mask63 = @immut_BitVector.bit_mask(63)
  assert_eq!(mask63, 1UL << 63)
}

///|
test "low_bits_mask_function" {
  // 测试低位掩码辅助函数
  let mask0 = @immut_BitVector.low_bits_mask(0)
  assert_eq!(mask0, 1UL)
  let mask3 = @immut_BitVector.low_bits_mask(3)
  assert_eq!(mask3, 15UL) // 1111 二进制
  let mask63 = @immut_BitVector.low_bits_mask(63)
  assert_eq!(mask63, @immut_BitVector.UINT64_MAX)
}

///|
test "lowest_set_bit_function" {
  // 测试查找最低的1位
  let num1 = 1UL // 二进制: 0...01
  assert_eq!(@immut_BitVector.lowest_set_bit(num1), 0)
  let num2 = 8UL // 二进制: 0...01000
  assert_eq!(@immut_BitVector.lowest_set_bit(num2), 3)
  let num3 = 0UL // 全0
  assert_eq!(@immut_BitVector.lowest_set_bit(num3), -1)
}

///|
test "exact_64bit_multiple" {
  // 测试长度刚好是64的倍数的情况
  let bv = @immut_BitVector.new(128)
  let bv2 = bv.set(63).set(64)
  assert_eq!(bv2.get(63), true)
  assert_eq!(bv2.get(64), true)

  // 测试边界
  let ones = @immut_BitVector.ones(64)
  assert_eq!(ones.count_ones(), 64)
  assert_eq!(ones.count_zeros(), 0)
}

///|
test "small_bitvector" {
  // 测试长度为1的特殊情况
  let bv = @immut_BitVector.new(1)
  assert_eq!(bv.length(), 1)
  assert_eq!(bv.get(0), false)
  let bv2 = bv.set(0)
  assert_eq!(bv2.get(0), true)

  // 长度为1的位向量的all_ones和all_zeros
  assert_eq!(bv.is_all_zeros(), true)
  assert_eq!(bv2.is_all_ones(), true)
}

///|
test "complex_slice_operations" {
  // 测试复杂的切片操作
  let bv = @immut_BitVector.from_string("1111111111")

  // 起始位置在一个字内
  let s1 = bv.slice(2, 6)
  assert_eq!(s1.length(), 4)
  assert_eq!(s1.to_string(), "1111")

  // 跨字边界的切片（构造更大的BitVector）
  let large_bv = @immut_BitVector.new(100)
  let large_bv2 = large_bv.set(62).set(63).set(64).set(65)
  let s2 = large_bv2.slice(62, 66)
  assert_eq!(s2.length(), 4)
  assert_eq!(s2.to_string(), "1111")
}

///|
test "complex_concat_operations" {
  // 测试复杂的拼接操作

  // 拼接的第一个向量长度是64的倍数
  let bv1 = @immut_BitVector.from_string("1010")
  let bv2 = @immut_BitVector.ones(64)
  let result1 = bv1.concat(bv2)
  assert_eq!(result1.length(), 68)
  assert_eq!(result1.get(0), true)
  assert_eq!(result1.get(1), false)
  assert_eq!(result1.get(2), true)
  assert_eq!(result1.get(3), false)
  for i in 4..<68 {
    assert_eq!(result1.get(i), true)
  }

  // 拼接后的位向量跨越多个字
  let bv3 = @immut_BitVector.ones(60)
  let bv4 = @immut_BitVector.ones(10)
  let result2 = bv3.concat(bv4)
  assert_eq!(result2.length(), 70)
  assert_eq!(result2.count_ones(), 70)
}

///|
test "chained_operations" {
  // 测试链式操作
  let bv = @immut_BitVector.new(10)
  let result = bv.set(1).set(3).set(5).set(7).set(9)
  assert_eq!(result.to_string(), "0101010101")

  // 组合多种操作
  let result2 = result.flip(0).flip(2).flip(4).flip(6).flip(8)
  assert_eq!(result2.to_string(), "1111111111")

  // 与、或、异或的组合
  let bv1 = @immut_BitVector.from_string("1100")
  let bv2 = @immut_BitVector.from_string("1010")
  let bv3 = @immut_BitVector.from_string("0101")
  let combined = bv1.and(bv2).or(bv3)
  assert_eq!(combined.to_string(), "1101")
}

///|
test "to_and_from_conversion" {
  // 测试相互转换的一致性
  let original = @immut_BitVector.from_string("10101100001111")

  // 字符串转换
  let str = original.to_string()
  let from_str = @immut_BitVector.from_string(str)
  assert_eq!(original.to_string(), from_str.to_string())

  // 布尔数组转换
  let bools = original.to_bools()
  let from_bools = @immut_BitVector.from_bools(bools)
  assert_eq!(original.to_string(), from_bools.to_string())
}

///|
test "large_bitvector_operations" {
  // 测试大型位向量的操作（超过一个UInt64）
  let bv1 = @immut_BitVector.new(200)
  let bv2 = @immut_BitVector.ones(200)

  // 测试大型位向量的位计数
  assert_eq!(bv1.count_ones(), 0)
  assert_eq!(bv2.count_ones(), 200)

  // 在边界处设置位
  let bv3 = bv1.set(63).set(64).set(127).set(128)
  assert_eq!(bv3.get(63), true)
  assert_eq!(bv3.get(64), true)
  assert_eq!(bv3.get(127), true)
  assert_eq!(bv3.get(128), true)
  assert_eq!(bv3.count_ones(), 4)
}

///|
test "find_first_set_complex" {
  // 测试复杂的find_first_set情况
  let bv1 = @immut_BitVector.new(200)
  assert_eq!(bv1.find_first_set(), -1)
  let bv2 = bv1.set(64) // 第二个UInt64的第一位
  assert_eq!(bv2.find_first_set(), 64)
  let bv3 = bv2.set(32) // 第一个UInt64的中间
  assert_eq!(bv3.find_first_set(), 32)
  let bv4 = @immut_BitVector.ones(128).clear(0)
  assert_eq!(bv4.find_first_set(), 1)
}

///|
// 测试空的 BitVector（长度为0）的构造与输出
test "empty_bitvector" {
  // 创建长度为0的位向量
  let bv = @immut_BitVector.new(0)
  assert_eq!(bv.length(), 0)
  assert_eq!(bv.count_ones(), 0)
  assert_eq!(bv.to_string(), "")
}

///|
// 测试全部置零与全部置一后再进行逻辑运算
test "all_zero_and_all_one_logic" {
  let zero_bv = @immut_BitVector.new(128)
  let one_bv = @immut_BitVector.ones(128)

  // 与操作：全1与全0得到全0
  let and_result = one_bv.and(zero_bv)
  assert_eq!(and_result.count_ones(), 0)

  // 或操作：全1与全0得到全1
  let or_result = one_bv.or(zero_bv)
  assert_eq!(or_result.count_ones(), 128)

  // 异或操作：全1与全0得到全1
  let xor_result = one_bv.xor(zero_bv)
  assert_eq!(xor_result.count_ones(), 128)
}

///|
// 测试链式操作：连续调用 set/clear/flip
test "chained_set_clear_flip" {
  let bv = @immut_BitVector.new(16)
  // 连续设置所有偶数位
  let mut curr = bv
  for i in 0..<16 {
    if i % 2 == 0 {
      curr = curr.set(i)
    }
  }
  // 验证偶数位为1，其他为0
  for i in 0..<16 {
    if i % 2 == 0 {
      assert_eq!(curr.get(i), true)
    } else {
      assert_eq!(curr.get(i), false)
    }
  }
  // 翻转第4位（偶数位），再清除第5位（奇数位，原本为0）
  let bv2 = curr.flip(4).clear(5)
  assert_eq!(bv2.get(4), false)
  assert_eq!(bv2.get(5), false)
}

///|
// 测试从布尔数组转换后再转换回字符串保持一致性
test "bools_to_string_roundtrip" {
  let bools = FixedArray::from_array([true, false, true, false, true])
  let bv = @immut_BitVector.from_bools(bools)
  let str = bv.to_string()
  // 期望得到 "10101"
  assert_eq!(str, "10101")
  let bv2 = @immut_BitVector.from_string(str)
  assert_eq!(bv2.to_string(), "10101")
}

///|
// 测试 slice 操作的边界情况
test "slice_boundary_cases" {
  // 创建一个长度为70位的向量，全1
  let bv = @immut_BitVector.ones(70)

  // 切出后半部分（例如从35到69），应得到35个1
  let slice1 = bv.slice(35, 70)
  assert_eq!(slice1.length(), 35)
  assert_eq!(slice1.count_ones(), 35)

  // 切出前半部分
  let slice2 = bv.slice(0, 35)
  assert_eq!(slice2.length(), 35)
  assert_eq!(slice2.count_ones(), 35)

  // 切空区间（起始与结束相同），长度应为0
  let empty_slice = bv.slice(10, 10)
  assert_eq!(empty_slice.length(), 0)
  assert_eq!(empty_slice.to_string(), "")
}

///|
// 测试序列化和反序列化：to_string 与 from_string
test "serialization_roundtrip" {
  let original = @immut_BitVector.from_string("1100101011110000")
  let serialized = original.to_string()
  let deserialized = @immut_BitVector.from_string(serialized)
  assert_eq!(original.to_string(), deserialized.to_string())
}

///|
/// 测试lowest_unset_bit函数
test "lowest_unset_bit_function" {
  // 测试正常情况，低位有一些0
  assert_eq!(@immut_BitVector.lowest_unset_bit(10UL), 0) // 1010二进制，最低位是0
  assert_eq!(@immut_BitVector.lowest_unset_bit(6UL), 0) // 0110二进制，最低位是0

  // 测试连续几个1后才有0的情况
  assert_eq!(@immut_BitVector.lowest_unset_bit(7UL), 3) // 0111二进制，第3位是第一个0
  assert_eq!(@immut_BitVector.lowest_unset_bit(15UL), 4) // 1111二进制，第4位是第一个0

  // 测试全为1的情况
  assert_eq!(@immut_BitVector.lowest_unset_bit(@immut_BitVector.UINT64_MAX), 64)
}

///|
/// 测试slice在字边界上跨越多个字的情况
test "slice_at_word_boundary_across_multiple_words" {
  // 创建一个跨越多个字（至少3个UInt64，即192位）的BitVector
  let length = 192
  let mut bv = @immut_BitVector.new(length)

  // 设置一些特定位，确保能验证正确复制
  bv = bv.set(64) // 第二个字的第一位
  bv = bv.set(127) // 第二个字的最后一位
  bv = bv.set(128) // 第三个字的第一位
  bv = bv.set(191) // 第三个字的最后一位

  // 从字边界开始切片，跨越多个字
  let slice1 = bv.slice(64, 192) // 从第二个字开始，到最后

  // 验证切片的长度和内容
  assert_eq!(slice1.length(), 128)
  assert_true!(slice1.get(0)) // 原来的第64位，现在是第0位
  assert_true!(slice1.get(63)) // 原来的第127位，现在是第63位
  assert_true!(slice1.get(64)) // 原来的第128位，现在是第64位
  assert_true!(slice1.get(127)) // 原来的第191位，现在是第127位

  // 还需要测试end_word处的掩码处理
  let slice2 = bv.slice(64, 130) // 从第二个字开始，到第三个字的第2位
  assert_eq!(slice2.length(), 66)
  assert_true!(slice2.get(0)) // 原来的第64位
  assert_true!(slice2.get(63)) // 原来的第127位
  assert_true!(slice2.get(64)) // 原来的第128位
  assert_false!(slice2.get(65)) // 原来的第129位
}

///|
/// 测试slice不在字边界上且跨越多个字的情况
test "slice_not_at_word_boundary_across_multiple_words" {
  // 创建一个跨越多个字的BitVector
  let length = 200
  let mut bv = @immut_BitVector.new(length)

  // 设置一些特定位置的值
  bv = bv.set(10) // 第一个字中间
  bv = bv.set(63) // 第一个字最后一位
  bv = bv.set(64) // 第二个字第一位
  bv = bv.set(100) // 第二个字中间
  bv = bv.set(127) // 第二个字最后一位
  bv = bv.set(128) // 第三个字第一位
  bv = bv.set(190) // 第三个字中间

  // 从非字边界开始，跨越多个字的切片
  let slice = bv.slice(10, 190)
  println("Original BitVector:")
  println("Bit 64 = " + bv.get(64).to_string())
  println("Slice Result:")
  println("Bit 54 = " + slice.get(54).to_string())
  // 验证切片的长度和内容
  assert_eq!(slice.length(), 180)
  assert_true!(slice.get(0)) // 原来的第10位
  assert_true!(slice.get(53)) // 原来的第63位
  assert_true!(slice.get(54)) // 原来的第64位
  assert_true!(slice.get(90)) // 原来的第100位
  assert_true!(slice.get(117)) // 原来的第127位
  assert_true!(slice.get(118)) // 原来的第128位

  // 测试源数据大小导致目标索引超出范围的情况
  // 创建一个正好使dst_idx在边界的BitVector
  let large_bv = @immut_BitVector.new(200)
  let slice2 = large_bv.slice(10, 138) // 这会导致切片结果有3个字，最后一个字只用一点点

  // 确保切片长度正确
  assert_eq!(slice2.length(), 128)
}

///|
/// 测试from_ints函数中处理非零余数的代码路径
test "from_ints_with_remainder" {
  // 创建一个长度不是64倍数的UInt64数组
  // 例如，创建一个长度为100位的位向量(需要2个UInt64)
  let ints = FixedArray::from_array([
      UINT64_MAX, // 第一个UInt64全为1
      UINT64_MAX,
    ], // 第二个UInt64全为1，但我们只需要使用前36位
  )

  // 创建长度为100的位向量
  let bv = @immut_BitVector.from_ints(ints, 100)

  // 验证长度正确
  assert_eq!(bv.length(), 100)

  // 验证前64位全为1
  for i in 0..<64 {
    assert_true!(bv.get(i))
  }

  // 验证接下来的36位也全为1
  for i in 64..<100 {
    assert_true!(bv.get(i))
  }
}

///|
/// 测试concat函数中第一个向量长度是64倍数的情况
test "concat_with_aligned_first_vector" {
  // 创建一个长度正好是64倍数的位向量
  let bv1 = @immut_BitVector.new(64)
  // 设置几个位以便我们可以验证数据是否正确拼接
  let bv1 = bv1.set(0).set(63)

  // 创建第二个位向量
  let bv2 = @immut_BitVector.new(10)
  let bv2 = bv2.set(0).set(9)

  // 拼接
  let result = bv1.concat(bv2)

  // 验证拼接后的长度
  assert_eq!(result.length(), 74)

  // 验证第一个位向量的位保持不变
  assert_true!(result.get(0))
  assert_true!(result.get(63))

  // 验证第二个位向量的位被正确添加
  assert_true!(result.get(64)) // bv2的第0位
  assert_true!(result.get(73)) // bv2的第9位
}

///|
/// 测试is_all_zeros函数中遍历多个UInt64的情况
test "is_all_zeros_with_multiple_uint64s" {
  // 创建一个包含多个UInt64的全0位向量
  let bv_zeros = @immut_BitVector.new(130) // 需要3个UInt64

  // 验证is_all_zeros返回true
  assert_true!(bv_zeros.is_all_zeros())

  // 创建一个第一个UInt64非0的位向量
  let bv_first_nonzero = @immut_BitVector.new(130)
  let bv_first_nonzero = bv_first_nonzero.set(10) // 设置第一个UInt64中的一个位

  // 验证is_all_zeros返回false
  assert_false!(bv_first_nonzero.is_all_zeros())

  // 创建一个中间UInt64非0的位向量
  let bv_middle_nonzero = @immut_BitVector.new(130)
  let bv_middle_nonzero = bv_middle_nonzero.set(65) // 设置中间UInt64中的一个位

  // 验证is_all_zeros返回false
  assert_false!(bv_middle_nonzero.is_all_zeros())
}

///|
/// 测试is_all_ones函数中遍历多个UInt64的情况
test "is_all_ones_with_multiple_uint64s" {
  // 创建一个包含多个UInt64的全1位向量
  let bv_ones = @immut_BitVector.ones(130) // 需要3个UInt64

  // 验证is_all_ones返回true
  assert_true!(bv_ones.is_all_ones())

  // 创建一个第一个UInt64不全为1的位向量
  let bv_first_not_all_ones = @immut_BitVector.ones(130)
  let bv_first_not_all_ones = bv_first_not_all_ones.clear(10) // 清除第一个UInt64中的一个位

  // 验证is_all_ones返回false
  assert_false!(bv_first_not_all_ones.is_all_ones())

  // 创建一个中间UInt64不全为1的位向量
  let bv_middle_not_all_ones = @immut_BitVector.ones(130)
  let bv_middle_not_all_ones = bv_middle_not_all_ones.clear(65) // 清除中间UInt64中的一个位

  // 验证is_all_ones返回false
  assert_false!(bv_middle_not_all_ones.is_all_ones())
}
