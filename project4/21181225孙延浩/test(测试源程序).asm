.data
.text
main:
    lui $t0 0		#赋值0
    lui $t1 0		#赋值0
    ori $t1,$t1,10	#给$t1寄存器赋值10
    lui $t4,0		#给$t4赋值0
    lui $t5,0		#赋值0
    ori $t5,$t5,4	#给$t5赋值4，作为DM地址递增量 
    lui $t6,0		#赋值0，作为累加结果
    labelFor:		#for循环的跳转点
    jal sum			#跳转到累加函数
    beq $t1,$t0,labelJump	#如果$t1内容减到0了就跳出for循环
    j labelFor			#用来建立循环，在上一步没跳出就继续
    labelJump:			#用来跳出循环的标记点
    subu $t4,$t4,$t5		#将$t4指向最后写入的内容
    lw $t1,0($t4)		#加载最后写入的内容到$t1
    lui $t6,0			#赋值0
    addu $t4,$t4,$t5		#将指向DM的指针移到下一块空内存单元
    ori $t0,$t0,55		#给$t0赋值55
    beq $t1,$t0,labelTest	#如果运算结果等于55就跳转
    addi $t6,$t6,1		#加1用来判断是否成功跳转，从而判断结果是否正确
    labelTest:			#跳转点
    addi $t6,$t6,1		#$t6值+1
    sw $t6,0($t4)		#如果最后写入的值是1证明累加1到10运算结果正确，否则不正确
    addu $t4,$t4,$t5		#将指向DM的指针移到下一块空内存单元
    lui $t6,0
    ori $t6,255
    lui $t2,0
    ori $t2,200
    slt $t3,$t6,$t2             #  ($t3)=(($t6)<($t2))? 1 : 0;
    sw $t3,0($t4)		#若为0 则指令正确执行
    addu $t4,$t4,$t5		#将指向DM的指针移到下一块空内存单元
    lui $t6,0
    lui $t2,0
    addi $t6,$t6,-10
    addi $t2,$t2,-2
    slt $t3,$t6,$t2             #  ($t3)=(($t6)<($t2))? 1 : 0;
    sw $t3,0($t4)		#若为1 则指令正确执行
    addu $t4,$t4,$t5		#将指向DM的指针移到下一块空内存单元
    LabelWhile:                 #开始死循环
    addi $t6,$t6,-1
    j LabelWhile
    syscall
sum:
    addu $t6,$t6,$t1  		#第i次循环把10-i+1累加
    sw $t6,0($t4)		#将每次的临时结果存入到DM
    addu $t4,$t4,$t5		#将指向DM的指针移到下一块空内存单元
    addiu $t1,$t1,-1		#$t1减一
    jr $ra              	#跳转出函数
