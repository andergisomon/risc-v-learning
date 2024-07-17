	
	.section .text
	.global	init_gpio

init_gpio:
	.equ GPIO_OUT_W1TS_REG, 0x60004008		# 0x6000 for peripherals, 0x....4000 for GPIO, and 0x....,...C for GPIO_OUT_W1TS_REG
	.equ GPIO_OUT_W1TC_REG, 0x6000400C		# Same logic as above line
	.equ GPIO_ENABLE_REG, 0x60004024		# Same logic as above line
	.equ GPIO_IN_REG, 0x6000403C			# Read-only register for digitalRead of GPIO
	.equ IO_MUX_GPIO4_FUN_IE, 0x60009020		# Register for configuring GPIO4 (SW1) modes - IO MUX and GPIO Matrix
	.equ IO_MUX_GPIO5_FUN_IE, 0x60009024		# Register for configuring GPIO5 modes (SW2) - IO MUX and GPIO Matrix

	.equ LED3, 0b000100				# Specify GPIO pin of LED3 - GPIO2 (D0)
	.equ LED4, 0b001000				# Specify GPIO pin of LED4 - GPIO3 (D1)
	.equ SW1, 0b010000				# Specify GPIO pin of SWITCH1 - GPIO4 (D2)
	.equ SW2, 0b100000				# Specify GPIO pin of SWITCH2 - GPIO5 (D3)

# LED3 is active LOW
	li t0, LED3					# Specify GPIO2 (D0 on the XIAO board)
	li t1, GPIO_ENABLE_REG				# Load enable OUTPUT register
	sw t0, 0(t1)					# Store the value t0 at address of t1 -- Here it means specifying GPIO2 as OUTPUT enabled.

# LED4 is active HIGH
	li a0, LED4					# Specify GPIO3 (D1 on the XIAO board)
	li a1, GPIO_ENABLE_REG					
	sw a0, 0(a1)

# Configure GPIO4 as input (SW1)
	li t0, 0b1100000000				# Specify enable INPUT and internal pullup (D2 on the XIAO board)
	li t1, IO_MUX_GPIO4_FUN_IE			# Load enable INPUT register
	sw t0, 0(t1)					# Write to config address

# Configure GPIO5 as input (SW2)
	li t0, 0b1100000000				# Specify enable INPUT and internal pullup (D3 on the XIAO board)
	li t1, IO_MUX_GPIO5_FUN_IE			# Load enable INPUT register
	sw t0, 0(t1)					# Write to config address

loop:
# Reserve register t2 for SW1 status
	li t1, GPIO_IN_REG
	lw t2, 0(t1)
	srli t2, t2, 4					# Shift GPIO_IN_REG contents 4 places to the right, adjusting for the position encoding of GPIO_IN_REG
	andi t2, t2, 0b1						

# Reserve register t3 for SW2 status
	li t1, GPIO_IN_REG
	lw t3, 0(t1)
	srli t3, t3, 5					# Shift GPIO_IN_REG contents 5 places to the right
	andi t3, t3, 0b1

    and t4, t2, t3                         		# Check if both SW1 and SW2 are pressed, store result in t4
    bnez t4, Both_SW1_SW2_pressed_action

    bnez t2, Only_SW1_pressed_action        		# Jump to action subroutine when SW1 is pressed, where it will be checked again that ONLY SW1 is pressed


Both_SW1_SW2_released_action:
	li t1, GPIO_OUT_W1TS_REG			# Load address of SET GPIO (SET here means GPIO value turns to HIGH)
	li t0, LED3
	sw t0, 0(t1)					# Turn off LED3 - Specify LED3 to be HIGH

	li a1, GPIO_OUT_W1TC_REG			# Load address of CLEAR GPIO (CLEAR here means GPIO value turns to LOW)
	li a0, LED4
	sw a0, 0(a1)					# Turn off LED4 - Specify LED4 to be LOW

	j loop

Only_SW1_pressed_action:
    	bnez t3, loop                           	# If SW2 is pressed, go back to main loop

	li t1, GPIO_OUT_W1TC_REG			# Load address of CLEAR GPIO (CLEAR here means GPIO value turns to lOW)
	li t0, LED3
	sw t0, 0(t1)					# Turn on LED3 - Specify LED3 to be LOW

	li a1, GPIO_OUT_W1TC_REG			# Load address of CLEAR GPIO (CLEAR here means GPIO value turns to LOW)
	li a0, LED4
	sw a0, 0(a1)					# Turn off LED4 - Specify LED4 to be LOW

	j loop

Both_SW1_SW2_pressed_action:
	li a1, GPIO_OUT_W1TS_REG			# Load address of SET GPIO (SET here means GPIO value turns to HIGH)
	li a0, LED4
	sw a0, 0(a1)					# Turn on LED4 - Specify LED4 to be HIGH

	li t1, GPIO_OUT_W1TS_REG			# Load address of SET GPIO (SET here means GPIO value turns to HIGH)
	li t0, LED3
	sw t0, 0(t1)					# Turn off LED3 - Specify LED3 to be HIGH

	j loop

.section .data
