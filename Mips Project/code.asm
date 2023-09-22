.data 
wrongInput: .asciiz "\nThis option isn't valid \n\n"
dict1: .asciiz "\nDoes the Dictionary File Exist [y for yes, n for no]? "
dict2: .asciiz "\nDictionary File is created ...."
dict3: .asciiz "\n\nEnter the Path of the dirctionary file: "
dictName: .asciiz "dictionary.txt"
outName: .asciiz "output.txt"
warning1: .asciiz "\nThis file doesn't exist"
menuString: .asciiz "\n\nEnter the following characters for the following operations:\nc: for compression\nd: for decompresssion\nq: to quit\n::::: " 
quiting: .asciiz "\n.\n..\nQuiting.........."
compressMessage: .asciiz "\n\nEnter the name of the file to be compressed: "
compressedMessage: .asciiz "\n\nEnter the name of the output file: "
decompressMessage: .asciiz "\n\nEnter the name of the file to be de-compressed: "
emptyDictMessage: .asciiz "\n\nSorry, but the dictionary does not include any data to decode the message :("
errorDictMessage: .asciiz "\n\nSorry, the dictionary does not include all the characters!!!!"

dictionary: .space 512
dataToCompress: .space 512
compressed: .space 512
dictPath: .space 20
compPath: .space 20
decompPath: .space 20

.text
.globl main
main:
	li $v0, 4
	la, $a0, dict1
	syscall 
	li $v0, 12
	li $a1, 1
	syscall 
	
	beq $v0, 0x79, fileExists
	beq $v0, 0x59, fileExists
	beq $v0, 0x6e, fileNotExists
	beq $v0, 0x4e, fileNotExists
	
	li $v0, 4
	la, $a0, wrongInput
	syscall 
	b main
	
fileExists:
	li $v0, 4
	la, $a0, dict3
	syscall 
	li $v0, 8
	la, $a0, dictPath
	li, $a1, 20
	syscall 
	move $t0, $a0 
    	jal removeNewLine
    	
	li $v0, 13           
    	la $a0, dictPath
    	li $a1, 0            
    	li $a2, 0
  	syscall
  	bltz $v0, fileNotExistsWithMessage
  	move $s6, $v0 
  	
	li $v0, 14
	move $a0, $s6 
	la, $a1, dictionary
	li $a2, 512         
    	syscall 
    	li $v0, 16
    	syscall
    	b Menu
	
fileNotExistsWithMessage:
	li $v0, 4
	la, $a0, warning1
	syscall 
	b end
	
fileNotExists:	
	li $v0, 4
	la, $a0, dict2
	syscall 
    	la $t0, dictPath
    	la $t1, dictName
    	jal copyDictName
	
Menu: 
	li $v0, 4
	la, $a0, menuString
	syscall 
	li $v0, 12
	li $a1, 1
	syscall 
	
	beq $v0, 0x63, compress
	beq $v0, 0x43, compress
	beq $v0, 0x64, decompress
	beq $v0, 0x44, decompress
	beq $v0, 0x71, end
	beq $v0, 0x51, end
	li $v0, 4
	la, $a0, wrongInput
	syscall 
	b Menu
	
compress:
	li $v0, 4
	la, $a0, compressMessage
	syscall 
	li $v0, 8
	la, $a0, compPath
	li, $a1, 20
	syscall 
	move $t0, $a0 
    	jal removeNewLine
	li $v0, 13           
    	la $a0, compPath
    	li $a1, 0            
    	li $a2, 0
  	syscall
  	bltz $v0, fileNotExistsWithMessage
  	move $s6, $v0 
  	li $v0, 14
	move $a0, $s6 
	la, $a1, dataToCompress
	li $a2, 512         
    	syscall 
    	li $v0, 16
    	syscall
    	la $t0, dataToCompress
    	la $t8, compressed
checkWord:
	lb $t1, 0($t0)
	beq $t1, 0 ,finishUpCompressing
	beq $t1, '\r' itIsnewLine
    	blt $t1, '0', notWord
    	ble $t1, '9', itIsWord
    	blt $t1, 'A', notWord
    	ble $t1, 'Z', itIsWord
    	blt $t1, 'a', notWord
    	ble $t1, 'z', itIsWord
    	b notWord

itIsnewLine:
	move $t2, $t0
	addi $t0, $t0, 2 
	b lookInDict	

itIsWord:
	move $t2, $t0 	
itIsWordLoop:
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	blt $t1, '0', lookInDict
    	ble $t1, '9', itIsWordLoop
    	blt $t1, 'A', lookInDict
    	ble $t1, 'Z', itIsWordLoop
    	blt $t1, 'a', lookInDict
    	ble $t1, 'z', itIsWordLoop
    	
lookInDict:
	move $t3, $t2
	li $t4, 0
	la $t5, dictionary
	lb $t6, 0($t5)
	beqz $t6, notInDict
lookInDictLoop:
	move $t2, $t3
	move $t7, $t5
	addi, $t4, $t4, 1
	addi $t5 $t5, 5
	subi $t2, $t2, 1
	subi $t5, $t5, 1
comparingLoop:
	addi $t2, $t2, 1
	addi $t5, $t5, 1
	bne $t2, $t0 skip1
	lb $t1, 0($t2)
	lb $t6, 0($t5)
	li $t9, 4
	beq $t6, '\r' foundInDict
	beq $t6, 0 foundInDict
skip1:	
	lb $t1, 0($t2)
	lb $t6, 0($t5)
	beq $t1, $t6, comparingLoop
	beqz $t6, notInDict
goTONextLineLoop:
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	beqz $t6, notInDict
	bne $t6, '\r', goTONextLineLoop
	addi $t5, $t5, 2
	lb $t6, 0($t5)
	bne $t6, '\r', skip2
	addi $t5, $t5, 2
skip2:
	b lookInDictLoop
	
notInDict:
	li $t9, 4
	la $s0, dictionary
	subi $t5, $t5, 1
	subi $s0, $s0, 1
	beq $t5, $s0, skipNewLine
	addi $t5, $t5, 1
	li $t1, '\r'
	sb $t1, 0($t5)
	addi, $t5, $t5, 1
	li $t1, '\n'
	sb $t1, 0($t5)
skipNewLine:
	addi $t5, $t5, 4
	addi $t8, $t8, 3
printValueLoop:
	li, $t7, 16
	div $t6, $t4, $t7
	mul $t7, $t6, $t7
	sub $t1, $t4, $t7
	move $t4, $t6    
	jal printingFunction
	sb, $t1, 0($t5)
	sb, $t1, 0($t8)
	subi $t5, $t5, 1
	subi $t8, $t8, 1
	subi $t9, $t9, 1
	bnez $t9, printValueLoop
	addi $t5, $t5, 5
	addi $t8, $t8, 5
	li $t1, ' '
	sb $t1, 0($t5)
	li $t1, '\n'
	sb $t1, 0($t8)
	addi $t5, $t5, 1
	addi $t8, $t8, 1
printWordInDictLoop:
	lb $t1, 0($t3)
	sb $t1, 0($t5)
	addi $t5, $t5, 1
	addi $t3, $t3, 1
	bne $t3, $t0, printWordInDictLoop
	b checkWord

foundInDict:
	lb $t1, 0($t7)
	sb $t1, 0($t8)
	addi $t7, $t7, 1
	addi $t8, $t8 1
	subi $t9, $t9, 1
	bnez  $t9, foundInDict
	lb $t1, 0($t2)
	beqz $t1, finishUpCompressing
	li, $t1, '\n' 
	sb $t1, 0($t8)
	addi $t8, $t8 1
	b checkWord
	

notWord:
	lb $t1, 0($t0)
	move $t2, $t0
	addi $t0, $t0, 1
	b lookInDict
	
printingFunction:
	ble $t1, 9, small
	addi $t1, $t1, 55
	jr $ra
small:
	addi $t1, $t1, 48
	jr $ra
	
finishUpCompressing:
	subi $t8, $t8, 1
	lb $t1, 0($t8)
	bne $t1, '\n', skipFixingLine
	li $t1, 0
	sb $t1, 0($t8)
skipFixingLine:
	li $v0, 4
	la, $a0, compressedMessage
	syscall 
	
	li $v0, 8
	la, $a0, decompPath
	li, $a1, 20
	syscall 
	move $t0, $a0 
    	jal removeNewLine
    	
    	la $t5, compressed
    	li $t7, 0
    	li $t6 'a'
countDecompSize:
	addi $t7, $t7, 1
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	bnez  $t6, countDecompSize
	li $v0, 13   
  	la $a0, decompPath  
  	li $a1, 1    
  	li $a2, 0     
  	syscall        
  	move $s6, $v0  
  	li $v0, 15    
  	move $a0, $s6  
  	la $a1, compressed  
  	move $a2, $t7
  	syscall        
  	li $v0, 16    
  	move $a0, $s6  
  	syscall
    	la $t5, dictionary
    	li $t7, 0
    	li $t6 'a'
countDictSize:
	addi $t7, $t7, 1
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	bnez  $t6, countDictSize
    	
    	li $v0, 13   
  	la $a0, dictPath  
  	li $a1, 1    
  	li $a2, 0     
  	syscall        
  	move $s6, $v0  
  	li $v0, 15    
  	move $a0, $s6  
  	la $a1, dictionary
  	move $a2, $t7
  	syscall        
  	li $v0, 16    
  	move $a0, $s6  
  	syscall
    	b end
    	
decompress:
	li $v0, 4
	la, $a0, decompressMessage
	syscall 
	li $v0, 8
	la, $a0, decompPath
	li, $a1, 20
	syscall 
	move $t0, $a0 
    	jal removeNewLine
	li $v0, 13           
    	la $a0, decompPath
    	li $a1, 0            
    	li $a2, 0
  	syscall
  	bltz $v0, fileNotExistsWithMessage
  	move $s6, $v0 
  	li $v0, 14
	move $a0, $s6 
	la, $a1, compressed
	li $a2, 512         
    	syscall 
    	li $v0, 16
    	syscall
    	
    	la $t5, dictionary
    	lb $t6, 0($t5)
    	beqz $t6, emptyDictionary
    	li $t9, 0
countDictLinesLoop:
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	bne $t6, '\r', notAnewLineSkip
	addi $t7, $t5, 2
	lb $t6, 0($t7)
	beq $t6, '\r', notAnewLineSkip
	addi $t9, $t9, 1
notAnewLineSkip:
	bnez $t6, countDictLinesLoop
	la $t0, dataToCompress
	la $t8, compressed
checkCode:
	li $t4, 4
	li $t2, 0
	li $t7, 16
checkCodeLoop:
	lb $t1, 0($t8)
	jal reversedPrintingFunction
	mul $t2, $t2, $t7
	add $t2, $t2, $t1
	addi $t8, $t8, 1
	subi $t4, $t4, 1
	bnez $t4, checkCodeLoop
	bgt $t2, $t9 dictMissing
	la $t5, dictionary
	li $t3, -1
checkDict2:
	addi $t3, $t3, 1
	addi $t5, $t5, 5
	move $t7, $t5
wordLineLoop:
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	beq $t6, '\r', inCaseLastWord
	beq $t6, 0, inCaseLastWord
	b wordLineLoop
inCaseLastWord:	
	addi $t5, $t5, 2
	bne $t3, $t2, checkDict2
	subi $t5, $t5, 2
printDecompressLoop:
	lb $t1, 0($t7)
	sb $t1, 0($t0)
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	bne $t7, $t5, printDecompressLoop
	lb $t1, 0($t8)
	beqz $t1, finishUpDecompressing
	addi $t8, $t8, 1
	b checkCode
	
	
	
reversedPrintingFunction:
	ble $t1, 57, small2
	subi $t1, $t1, 55
	jr $ra
small2:
	subi $t1, $t1, 48
	jr $ra	

emptyDictionary:
	li $v0, 4
	la, $a0, emptyDictMessage
	syscall 
	b end
	
dictMissing:
	li $v0, 4
	la, $a0, errorDictMessage
	syscall 
	b end
	
finishUpDecompressing:
	li $v0, 4
	la, $a0, compressedMessage
	syscall 
	
	li $v0, 8
	la, $a0, compPath
	li, $a1, 20
	syscall 
	move $t0, $a0 
    	jal removeNewLine
    	
    	la $t5, dataToCompress
    	li $t7, 0
    	li $t6 'a'
countCompSize:
	addi $t7, $t7, 1
	addi $t5, $t5, 1
	lb $t6, 0($t5)
	bnez  $t6, countCompSize
	li $v0, 13   
  	la $a0, compPath  
  	li $a1, 1    
  	li $a2, 0     
  	syscall        
  	move $s6, $v0  
  	li $v0, 15    
  	move $a0, $s6  
  	la $a1, dataToCompress
  	move $a2, $t7
  	syscall        
  	li $v0, 16    
  	move $a0, $s6  
  	syscall
    	b end

removeNewLine:
	lb $t1, 0($t0)
	add $t0, $t0, 1
	bne $t1, '\n', removeNewLine
	li $t1, 0
	subi $t0, $t0 1
	sb $t1, 0($t0)
	jr $ra
	
copyDictName:
	lb $t2, 0($t1)
	sb $t2, 0($t0)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	bnez $t2, copyDictName
	jr $ra
	
end:
	li $v0, 4
	la, $a0, quiting
	syscall
	li $v0, 10           
  	syscall 
