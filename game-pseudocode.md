LOOP
	BEGIN
	
		* READ KEYS
		* PRINT SCREEN
		* GAME LOGIC
	END


READ KEYS
	BEGIN
	
		* TERMINAL-KEYPRESS CALL
		* EXTRACT KEY VALUE FROM OBJECT
		* TEST VALUE
		* SET FLAG FOR GAME-LOGIC
	
	END

PRINT SCREEN
	BEGIN
	
		* READ SCREEN VARIABLE CONTENTS
		* PRINT SCREEN
		
	END
	
GAME LOGIC
	BEGIN
	
		* READ KEY PRESS FLAG
		* <<ACTUAL GAME LOGIC>>
		* WAIT FOR NEXT FRAME		
		* SET SCREEN VARIABLE FROM GAME LOGIC STATE

	END


=====

- Set up X variable = 0
- X can be 0 to 9 inclusive, but no more or less
- Randomly generate number (rng-move) between 0 and 4
- Set up character-gfx list: (sit-forwards[0], sit-left[1], sit-right[2], move left[3], move right[4])
- if rng-move = 0, 1, or 2, change frame, but don't modify X
- if rng-move = 3, and X > 0 DECF X
- if rng-move = 4, and X < 9 INCF X
- select (nth rng-move character-gfx)

and

- concatenate X number of spaces to left of character-gfx

(apply #'concatenate 'string (list (subseq "         " *movement*)
(nth *rng-move* uwu-gfx)))

====

6 July 2020

# GRAPHICS + DATA

- Egg
- Baby
- Child
- Teen
- Adult

# VARIABLES

## Pet State

- Happiness
- Secret Happiness
- Hunger
- Secret Hunger
- Poop
- Attention
- Neglect
- Illness
- Life Cycle
- Age Global
- Age Current Stage
- Skill Smart, Creative, Social

## Auxiliary

- Key press
- Frame counter
- Movement
- RNG Movement
- Pet appearance

# GAME CODE

## Main Loop

### Initialisation

- s

### Read keys
### Process input
### Process state

===

egg:

- set a timer for 5 minutes
- update the screen every second 

baby:

- RNG out of two possibilities for either lawful or chaotic
- set hunger and happiness to zero
- set a timer for an hour
- decrease hunger and happiness one point every 10 minutes

child:

- RNG out of 4 possibilities for the species of the pet
- carry over hunger and happiness from previous stage
- set timer for 24 hours
- decrease hunger and happiness once every 5 hours
- start the counter for neglect points

teen:

-
-

adult:

-
-
