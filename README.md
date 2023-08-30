This project is a game where you avoid/shoot spawning enemies and try to survive as long as possible!
The code has 5 main parts:
1. object oriented programming with classic.lua
2. the use of tables to store bullet & enemy information
3. the use of a nested for loop to iterate through all bullets and enemies
4. the creation of a menu and buttons through tables
5. gamestates

When you click the start button, the gamestate changes accordingly, and the backdrop shifts
When you click the exit button, the game closes

During gameplay, you can shoot bullets. Enemies will spawn at a certain interval
Small enemies spawn at your x axis (could be considered as torpedos)
Middle and large enemies spawn at random x coordinates
The enemies all travel down at a straight line. The challenge comes fron spacing.
Small enemies don't have a large health pool, but travel fast
Medium enemies have a balance between health and speed
Large enemies are slow, but they can soak up a lot of damage

The player needs to determine which enemies to evade and which enemies to shoot down. 
(there is a limit to brute forcing, as focusing at a single enemy makes you a good target)
