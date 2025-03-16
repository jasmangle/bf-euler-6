[         Brainfuck Project Euler Problem 6 (32 Bit Registers Required)        ]
[               Written by Jasmine Angle | angle@berkeley(dot)edu              ]

[             Completed as part of the Spring 2025 iteration of the            ]
[           Esoteric Programming Languages DeCal Course at UC Berkeley         ]

[                 Variable length value printing algorithm from                ]
[               https://esolangs(dot)org/wiki/brainfuck_algorithms             ]

# First Part: Sum up the first 100 natural numbers

# Create initial 100
>++++++++++[<++++++++++>-]<
# Now at 0x00

# Have to keep 2 copies:
# First copy at 01 to copy back later
# Second copy at 02 to sum into result (03)
[
  [->+>+<<]     # Makes 2 copies at 01 and 02
  >>            # Move to 02
  [->+<]        # Move 02 into 03 (03 = 02 add 03)
  <[-<+>]       # Copy 01 back to 00
  <-            # Decrement 00
  # Position is 00
]
>>>

# Now we need to find the square of the sum of the natural numbers:

# Have to keep 2 copies again:
# First copy already at 0x05 (moved from 0x04)
# Second copy at 0x08

[
  [->+>+<<]    # Copy 0x04 to 0x06 and 0x07

  # Multiply routine (0x08 = 0x05 mul 0x06) 
  # 0x05 = Operand
  # 0x06 = Operand
  # 0x07 = Temporary Holding Value
  # 0x08 = Product
  >>            # Move pointer to 0x06 (Operand 2)
  [
    <           # Back to 0x05 (Operand 1)
    [
      >>+>+     # Increment 0x07 (Temp) and 0x08 (Product)
      <<<-      # Decrement 0x05 (Operand 1)
    ]
    >-          # Decrement 0x06 (Operand 2) for next iter
    >[<<+>>-]   # Move 0x07 (Temp) to 0x05 (Operand 1) 
    <           # Back to 0x06 (Operand 2)
  ]
]

# By this point, we have:
# 0x04 = Sum of first 100 natural numbers
# 0x08 = Square of Sum

# Sum of squares (backwards from 100 to 1)

<<<<<          # Back to 0x00
>>++++++++++[<++++++++++<++++++++++>>-]<<  # Create 100 at 0x00 and 0x01
# Pointer currently at 0x00
[
  # Multiply routine (0x03 = 0x00 mul 0x01) 
  # 0x00 = Operand
  # 0x01 = Operand
  # 0x02 = Temporary Holding Value
  # 0x03 = Product
  >             # Move pointer to 0x02 (Operand 2)
  [
    <           # Back to 0x05 (Operand 1)
    [
      >>+>+     # Increment 0x07 (Temp) and 0x08 (Product)
      <<<-      # Decrement 0x05 (Operand 1)
    ]
    >-          # Decrement 0x06 (Operand 2) for next iter
    >[<<+>>-]   # Move 0x07 (Temp) to 0x05 (Operand 1) 
    <           # Back to 0x06 (Operand 2)
  ]
  <-            # Decrement 0x00
  [->+>+<<]     # Copy 0x00 to 0x01 and 0x02
  >>            # Move back to 0x02
  [-<<+>>]<<    # Copy 0x02 back to 0x00
  
]

# Now we have:
# 0x03 = Sum of squares of first 100 natural numbers
# 0x04 = Sum of first 100 natural numbers
# 0x07 = Square of sums of first 100 natural numbers
# We want to let 0x07 = 0x07 sub 0x03

>>>             # Get to 0x03
[->>>>-<<<<]    # Decrement 0x03 and 0x07 until 0x03 = 0
>>>>
# Result is stored in 0x07

# Print output as an integer
# Credit: https://esolangs(dot)org/wiki/brainfuck_algorithms
>[-]>[-]+>[-]+<                         // Set n and d to one to start loop
[                                       // Loop on 'n'
    >[-<-                               // On the first loop
        <<[->+>+<<]                     // Copy V into N (and Z)
        >[-<+>]>>                       // Restore V from Z
    ]
    ++++++++++>[-]+>[-]>[-]>[-]<<<<<    // Init for the division by 10
    [->-[>+>>]>[[-<+>]+>+>>]<<<<<]      // full division
    >>-[-<<+>>]                         // store remainder into n
    <[-]++++++++[-<++++++>]             // make it an ASCII digit; clear d
    >>[-<<+>>]                          // move quotient into d
    <<                                  // shuffle; new n is where d was and
                                        //   old n is a digit
    ]                                   // end loop when n is zero
<[.[-]<]                                // Move to were Z should be and
                                        // output the digits till we find Z
# Final pointer location at 0x08
