.data
	size1:			 .word 0 # for storing map row
	size2:			 .word 0 # for stroing map column
	inpMessage1:     .asciiz "Enter size of row : "
	inpMessage2:     .asciiz "Enter size of column: "
	inpMessage3:	 .asciiz "Enter content of map:"
	newLine:		 .asciiz "\n"

.text

.globl main # defining global main	
	
####################################  main START  ##############################################################################################
main:
# WE GET THE NECESSARY INPUTS FROM THE USER
	li $v0, 4			 # put 4 in the v0 register for printing
	la $a0, inpMessage1  # load message to a0 register
	syscall				 # perform the system call	
	# get size1
	li $v0, 5
	syscall
	sw $v0, size1
	
	li $v0, 4			 # put 4 in the v0 register for printing
	la $a0, inpMessage2  # load message to a0 register
	syscall				 # perform the system call	
	# get size2
	li $v0, 5
	syscall
	sw $v0, size2

# WE ALLOCATE MEMORY TO BOTH ARRAYS
	lw $t0, size1		# content of size1 -> t0
	lw $t1, size2		# content of size2 -> t1
	mul $t2, $t0, $t1	# calculating size of memory
	
	li $v0, 9			# instruction for memory allocation
	move $a0, $t2		# put the amount of memory to allocate in a0
	syscall				# perform the system call
	move $s6, $v0		# v0 registerındaki adres değerini s6'a al (s6 -> bombArray)
	
	li $v0, 9			# instruction for memory allocation
	move $a0, $t2		# ayırılıcak bellek miktarını a0'a koy
	syscall				# perform the system call
	move $s7, $v0		# v0 registerındaki adres değerini s7'e al (s7 -> timeFlag)
	
	jal get_content_of_map
	jal print_map
	jal sprinkle_bomb
	jal print_map
	jal bombing
	jal print_map
	
end_program:
	li $v0, 10 			# exit() - system call equivalent (return 0;)
	syscall				# perform the system call
####################################  main END  ################################################################################################
####################################  get_content_of_map START  ################################################################################
get_content_of_map:
    lw $t0, size1           # size1 -> t0
    lw $t1, size2           # size2 -> t1
    la $t6, ($s6)         	# bombMap -> a0
    la $t7, ($s7)        	# timeFlag -> a1
    li $t2, 0               # i = 0 (dış döngü değişkeni)

    out_loop:
        bge $t2, $t0, end_out_loop  # if(i == size1) -> end_loop_out
        li $t3, 0                   # j = 0 (iç döngü değişkeni)

        in_loop:
            bge $t3, $t1, end_in_loop   # if(j == size2) -> end_loop_in            
            # printing input message
    		li $v0, 4
    		la $a0, inpMessage3
    		syscall 
            li $v0, 12                  # kullanıcıdan karakter oku
            syscall                     # perform the system call            
            sb $v0, 0($t6)         		# bombMap[i][j] = 'o'
            lb $t8, 0($t6)            
            li $v0, 12                  # \n ignore et
            syscall                     # perform the system call                 	
            # Girilen karakter 'o' ise timeFlag değerini 'x' olarak ve bombMap'e 'o' olarak sakla
            beq $t8, 'o' , set_x 
            # Girilen karakter '.' ise timeFlag değerini 'y' olarak ve bombMap'e '.' olarak sakla
            beq $t8, '.' set_y

            set_x:				
                li $t5, 'x'
                sb $t5, 0($t7)          # timeFlag[i][j] = 'x'
                j continue_in_loop

            set_y:           
                li $t5, 'y'
                sb $t5, 0($t7)          # timeFlag[i][j] = 'y'

        continue_in_loop:        				
            addi $t6, $t6, 1            # bombMap indeksini sonraki elemana al
            addi $t7, $t7, 1            # timeFlag indeksini sonraki elemana al
            addi $t3, $t3, 1            # j++
            j in_loop                   # iç döngü tekrarlansın

        end_in_loop:        
            addi $t2, $t2, 1            # i++
            j out_loop                  # dış döngü tekrarlansın

    end_out_loop:  	
		jr $ra
####################################  get_content_of_map END  ##################################################################################	
####################################  print_map START  #########################################################################################	
print_map:
	# yeni satır atıyoruz
	li $v0, 4
	la $a0, newLine
	syscall		
	lw $t0, size1			# size1 -> t0
	lw $t1, size2			# size2 -> t1
	la $t6, ($s6)			# bombMap -> a1
	li $t2, 0				# i = 0 dış döngü değişkeni
	
	out_loop_print:		
		bge $t2, $t0, end_out_loop_print
		li $t3, 0			# j = 0 iç döngü değişkeni
		
		in_loop_print:		
			bge $t3, $t1, end_in_loop_print
			lb $t4, 0($t6)			# t6'da tutulan elemanı t4'e yükle
			move $a0, $t4			# bu elemanı a0 registerına koy
			li $v0, 11				# print character
			syscall					# perform the system call
			li $v0, 11				# print character
			li $a0, ' '				# character ' ' to register a0
			syscall					# perform the system call
			addi $t6, $t6, 1		# bombMap[x] -> bombMap[x++]
			addi $t3, $t3, 1		# j++	
			j in_loop_print
			
		end_in_loop_print:			
			li $v0, 4				# print string
			la $a0, newLine			# newLine string to register a0
			syscall					# perform system call
			addi $t2, $t2, 1		# i++
			j out_loop_print
			
	end_out_loop_print:		
		jr $ra
####################################  print_map END  #########################################################################################	
####################################  sprinkle_bomb START  #########################################################################################	
sprinkle_bomb:
	lw $t0, size1		# size1 -> register t0
	lw $t1, size2		# size2 -> register t1
	la $t6, ($s6)		# adress of bombMap to register t6
	li $t2, 0			# i = 0 out loop variable
	
	out_loop_sprinkle:	
		bge $t2, $t0, end_out_loop_sprinkle
		li $t3, 0		# j = 0 in loop variable
		
		in_loop_sprinkle:			
			li $t5, 'o'
			bge $t3, $t1, end_in_loop_sprinkle		# end loop condition
			beq $t6, $t5, end_in_loop_sprinkle		# if the character inside is 'o', end the loop
			sb $t5, 0($t6)							# bombMap[i][j] = 'o'			
			addi $t6, $t6, 1						# bombMap[x] -> bombMap[x++]
			addi $t3, $t3, 1						# j++			
			j in_loop_sprinkle
		
		end_in_loop_sprinkle:			
			addi $t2, $t2, 1						# i++
			j out_loop_sprinkle
	
	end_out_loop_sprinkle:	
		jr $ra
####################################  sprinkle_bomb END  #########################################################################################				
####################################  bombing START  #########################################################################################		
bombing:		
    lw $t0, size1          # size1 -> t0
    lw $t1, size2          # size2 -> t1
    la $t5, ($s6)          # bombMap -> a1
    la $t6, ($s7)          # timeFlag -> a2
    li $t7, '.'            # If the condition is met, we will put it in.
    add $t2, $zero,$zero   # i = 0 out loop variable
    
    out_loop_bombing:		
        bge $t2, $t0, end_out_loop_bombing		# out loop condition
        add $t3, $zero, $zero          			# j = 0 in loop variable

		in_loop_bombing:			
    		bge $t3, $t1, end_in_loop_bombing   # end loop condition
    		lb $t9, 0($t5)                      # load value bombMap[i][j] to register t9
    		lb $s0, 0($t6)                      # load value timeFlag[i][j] to register s0 		
    		beq $t9, 'o', check_timeFlag		# if element is 'o' go check statement
   			j continue_in_loop_bombing

    		check_timeFlag:				
        		beq $s0, 'x', set_bombMap		# if the bomb is old (i.e. x) go        		  
        		j continue_in_loop_bombing

        	set_bombMap:      	
            	sb $t7, 0($t5)           		# bombMap[i][j] = '.'
            	# up cell
            	beq $t2, 0, skip_top  			# skip if the index is not an array element
				sub $t5, $t5, $t1 				# go to the top
            	sb $t7, 0($t5)           		# array[i-1][j] = '.'            	
            	add $t5, $t5, $t1				# get down
            
            skip_top:
            	# bottom cell
            	sub $s3, $t0, 1
            	bge $t2, $s3, skip_bottom		# skip if there are no array elements below that index
				add $t5, $t5, $t1           	# go to the bottom				
				add $t6, $t6, $t1				# move timeFlag to bottom index
				lb $t4, ($t6)					# put the value there in t4
				sub $t6, $t6, $t1				# set the timeFlag back
				beq $t4, 'x', skip_t5			# if the received value is x				
            	sb $t7, 0($t5) 					# array[i+1][j] = '.'
            	   
            	# we need to get in here anyway so we don't lose the index      		
            	skip_t5:					            	
            		sub $t5, $t5, $t1				# come back to the base
            
            skip_bottom:
            	# left cell
            	beq $t3, 0, skip_left			# skip if the left side of that index is not an array element
				sub $t5, $t5, 1					# go to the left index
            	sb $t7, 0($t5)          		# array[i][j-1] = '.'
				add $t5, $t5, 1					# go back to the right
            
            skip_left:
            	# right cell
            	sub $s7, $t1, 1
            	bge $t3, $s7, skip_right		# skip if the right side of that index is not an array element
				add $t5, $t5, 1					# go to the right index	
				addi $t6, $t6, 1				# move timeFlag to the right cell
				lb $t8, ($t6)					# put the value there on the t8
				subi $t6, $t6, 1				# set timeFlag back in place		
				beq $t8, 'x', skip_t5_				
            	sb $t7, 0($t5)          		# array[i][j+1] = '.'
            	
            	# we need to get in here anyway so we don't lose the index     		            	
            	skip_t5_:           		
            		sub $t5, $t5, 1					# come back to the left element
            	
            skip_right:
            	j continue_in_loop_bombing

    	continue_in_loop_bombing:   	
       		addi $t5, $t5, 1			# go to the next element of bombMap
        	addi $t6, $t6, 1			# go to the next element of timeFlag
        	addi $t3, $t3, 1			# j++
        	j in_loop_bombing

		end_in_loop_bombing:		
    		addi $t2, $t2, 1			# i++
    		j out_loop_bombing

	end_out_loop_bombing:	
		jr $ra
####################################  PROGRAM END  #############################################################################################	













