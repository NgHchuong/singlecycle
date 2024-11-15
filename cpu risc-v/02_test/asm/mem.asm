andi x19, x20, 255
slli x30, x31, 1
blt x9, x10, label9
xor x22, x23, x24
lw x4, 4(x5)
jal x11, offset2
bne x7, x8, label8
add x1, x2, x3
label9: srli x4, x5, 4
beq x12, x13, label1
slti x25, x26, 20
offset2: sb x31, 1(x1)
label8: slt x21, x22, x23
sra x8, x9, x6
lbu x10, 7(x11)
label1: bltu x18, x19, label4
or x16, x17, x18
jalr x25, x26, 0
label4: add x4, x5, x6
lui x28, 0x20000
bge x20, x21, label5
sltu x24, x25, x26
lh x8, 6(x9)
lhu x12, 8(x13)
srai x3, x4, 3
label5: sh x2, 2(x3)
sll x31, x1, x2
addi x14, x15, 1
ori x14, x15, 1
lw x11, 4(x12)
auipc x27, 0x1000
slli x2, x3, 3
xori x9, x10, 15
lb x6, 5(x7)
add x10, x11, x12
sw x12, 0(x13)
bgeu x22, x23, label6
sltiu x29, x30, 12
label6: sh x5, 3(x6)
sltu x27, x28, x29
label2: srli x4, x5, 4
srai x8, x9, 6
offset1: xor x14, x15, x16
andi x19, x20, 255
beq x14, x15, label2
bne x26, x27, label8
blt x1, x2, label3
lb x12, 1(x13)
jal x24, offset1
add x1, x2, x3
ori x10, x11, 1
label3: slli x30, x31, 1
sb x31, 0(x1)
sra x8, x9, x5
lbu x10, 3(x11)
slt x21, x22, x23
xor x6, x7, x8
slli x2, x3, 3
lui x27, 0x10000
sw x30, 8(x31)
beq x20, x21, label5
bltu x22, x23, label6
and x16, x17, x18
lbu x12, 2(x13)
label7: lh x8, 4(x9)
lw x4, 0(x5)
lhu x10, 7(x11)
slti x27, x28, 5
srl x4, x5, x3
bne x14, x15, label7
slli x30, x31, 1
jalr x25, x26, 0
beq x9, x10, label9
and x19, x20, x21
ori x14, x15, 0
blt x16, x17, label3
addi x4, x5, 10
sw x12, 2(x13)
slti x25, x26, 20
lui x28, 0x20000
slt x14, x15, x16
jal x11, offset2
bge x1, x2, label1
blt x18, x19, label4
srai x3, x4, 2
xor x6, x7, x8
add x10, x11, x12
sb x31, 1(x1)
beq x9, x10, label9
bne x7, x8, label8
bltu x18, x19, label4
andi x19, x20, 128
sltu x24, x25, x26
sw x4, 0(x5)
ori x1, x2, 255
lh x8, 2(x9)
slli x14, x15, 2
xori x30, x31, 1
sra x6, x7, x2
slli x30, x31, 1
