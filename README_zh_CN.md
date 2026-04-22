# immut_BitVector


[English](https://github.com/moonbit-community/immut_BitVector/blob/main/README.md) | [简体中文](https://github.com/moonbit-community/immut_BitVector/blob/main/README_zh_CN.md)  



[![Build Status](https://img.shields.io/github/actions/workflow/status/moonbit-community/immut_BitVector/ci.yml)](https://github.com/moonbit-community/immut_BitVector/actions)  [![codecov](https://codecov.io/gh/moonbit-community/immut_BitVector/branch/main/graph/badge.svg)](https://codecov.io/gh/moonbit-community/immut_BitVector)  

immut_BitVector是一个高效的不可变位向量数据结构，用于紧凑且高效地存储和操作布尔序列。它提供了一系列位操作，同时保持不可变性（所有修改操作都返回新的immut_BitVector实例）。

## 🚀 主要特性
• 🔄 多种构造方法 - 支持创建空向量、全0向量、全1向量，以及从布尔数组、整数数组或字符串创建  
• ➕ 基本位操作 - 获取、设置、清除和翻转特定位置的位  
• 🔀 逻辑操作 - 支持按位与、或、异或等操作  
• 🔢 位统计与查找 - 计算1和0的数量，查找第一个设置位  
• ✂️ 切片与连接 - 提取子向量和合并向量  
• 📊 序列化 - 转换为字符串或布尔数组  
• 🛠️ 工具方法 - 检查是否全0、全1等实用功能  

## 📥 安装
```bash
moon add kesmeey/immut_BitVector
```

## 🚀 使用指南

### 🔨 创建位向量
你可以使用`new()`、`ones()`、`from_bools()`、`from_ints()`或`from_string()`方法创建位向量。

```moonbit
// 创建一个全0的位向量
let bv1 = @immut_BitVector.new(10)  // 长度为10的全0位向量

// 创建一个全1的位向量
let bv2 = @immut_BitVector.ones(10)  // 长度为10的全1位向量

// 从布尔数组创建
let bools = FixedArray::make(5, false)
bools[1] = true
bools[3] = true
let bv3 = @immut_BitVector.from_bools(bools)  // 结果为"01010"

// 从字符串创建
let bv4 = @immut_BitVector.from_string("10110")  // 从二进制字符串创建

// 从整数数组创建
let ints = FixedArray::make(2, (0).to_uint64())
ints[0] = (42).to_uint64()  // 二进制：...0101010
let bv5 = @immut_BitVector.from_ints(ints, 128)  // 长度为128位的向量
```

### ➕ 基本位操作
使用`get()`、`set()`、`clear()`和`flip()`方法操作特定位置的位。

```moonbit
let bv = @immut_BitVector.new(10)  // 创建全0位向量

// 获取位值
let bit = bv.get(3)  // 获取索引3处的位值，返回false

// 设置位（返回新位向量）
let bv2 = bv.set(3)  // 将索引3处的位设为1
assert_eq(bv2.get(3), true)
assert_eq(bv.get(3), false)  // 原位向量不变

// 清除位
let bv3 = bv2.clear(3)  // 将索引3处的位清为0
assert_eq(bv3.get(3), false)

// 翻转位
let bv4 = bv.flip(5)  // 翻转索引5处的位
assert_eq(bv4.get(5), true)

// 翻转所有位
let bv5 = bv.flip_all()  // 翻转所有位
assert_eq(bv5.get(0), true)
```

### 🔀 逻辑操作
使用`bitwise_and()`、`bitwise_or()`、`xor()`和`bitwise_not()`方法进行按位逻辑运算。

```moonbit
let bv1 = @immut_BitVector.from_string("1100")
let bv2 = @immut_BitVector.from_string("1010")

// 按位与
let and_result = bv1.bitwise_and(bv2)  // "1000"

// 按位或
let or_result = bv1.bitwise_or(bv2)  // "1110"

// 按位异或
let xor_result = bv1.xor(bv2)  // "0110"

// 按位非（翻转所有位）
let not_result = bv1.bitwise_not()  // "0011"
```

### 🔢 位统计和查找
使用`count_ones()`、`count_zeros()`和`find_first_set()`方法来统计和查找位。

```moonbit
let bv = @immut_BitVector.from_string("101100")

// 计算1的数量
let ones = bv.count_ones()  // 3

// 计算0的数量
let zeros = bv.count_zeros()  // 3

// 查找第一个设置为1的位的位置
let first_set = bv.find_first_set()  // 0（从0开始的索引）
```

### ✂️ 切片和连接
使用`slice()`和`concat()`方法提取子向量和合并向量。

```moonbit
let bv = @immut_BitVector.from_string("1011001010")

// 切片（左闭右开）
let slice = bv.slice(2, 6)  // "1100"

// 连接两个位向量
let bv2 = @immut_BitVector.from_string("0101")
let concat_result = bv.concat(bv2)  // "10110010100101"
```

### 📊 序列化
使用`to_string()`和`to_bools()`方法将位向量转换为其他格式。

```moonbit
let bv = @immut_BitVector.from_string("10110")

// 转换为字符串
let str = bv.to_string()  // "10110"

// 转换为布尔数组
let bools = bv.to_bools()  // [true, false, true, true, false]
```

### 🛠️ 工具方法
使用`is_all_zeros()`、`is_all_ones()`和`length()`等方法获取位向量的状态。

```moonbit
let bv1 = @immut_BitVector.new(10)  // 全0位向量
let bv2 = @immut_BitVector.ones(10)  // 全1位向量

// 检查是否全0
assert_true(bv1.is_all_zeros())
assert_false(bv2.is_all_zeros())

// 检查是否全1
assert_true(bv2.is_all_ones())
assert_false(bv1.is_all_ones())

// 获取长度
assert_eq(bv1.length(), 10)

// 创建位掩码
let mask = @immut_BitVector.bit_mask(3)  // 在位置3创建掩码（...0001000）
let low_mask = @immut_BitVector.low_bits_mask(3)  // 从0到位置3创建掩码（...0001111）
```

## 🚀 高级使用示例

### 示例：使用BitVector实现简单的集合

```moonbit
// 使用BitVector表示包含0-9元素的集合
let set_a = @immut_BitVector.from_string("1010100101")  // 包含元素0,2,4,7,9
let set_b = @immut_BitVector.from_string("1100011001")  // 包含元素0,3,4,5,8,9

// 集合操作
let union = set_a.bitwise_or(set_b)         // 并集
let intersection = set_a.bitwise_and(set_b)  // 交集
let difference = set_a.xor(set_b)    // 对称差

// 打印结果
println("集合A: " + set_a.to_string())      // 1010100101
println("集合B: " + set_b.to_string())      // 1100011001
println("并集: " + union.to_string())       // 1110111101
println("交集: " + intersection.to_string()) // 1000000001
println("对称差: " + difference.to_string()) // 0110111100
```

### 示例：使用BitVector进行高效位操作

```moonbit
// 创建一个长度为128的位向量，用于位域操作
let flags = @immut_BitVector.new(128)

// 设置不同的标志位
let flags = flags.set(5).set(10).set(42).set(100)

// 检查标志位
if flags.get(10) {
  println("标志10已设置")
}

// 使用掩码进行批量操作
let mask = @immut_BitVector.from_string("00111100")  // 位掩码
let masked = flags.slice(0, 8).bitwise_and(mask)  // 应用掩码到前8位

println("应用掩码后: " + masked.to_string())
```

## 📜 许可证
本项目采用Apache-2.0许可证。详情请参见LICENSE文件。

## 📢 联系方式与支持
• Moonbit社区：moonbit-community  
• GitHub问题：[报告问题](https://github.com/kesmeey/immut_BitVector/issues)

👋 如果您喜欢这个项目，请给它一个⭐！祝编程愉快！🚀
