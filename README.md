# AndreeaStanculete

'Quest' is a simple RPG game combining elements from Zelda and Undertale, in which the player embarks on a quest to gather several rubies. Each precious stone is stored away safely in a locked chest, which the player must open.

Unfortunatelly for the player, things are a little more complicated than that. Each chest is guarded round the clock by undead skeletons. One of them surely must have the key to open it... if only we knew which one.

Showcase: https://www.youtube.com/watch?v=GdZXS60_nrs

## Motivation

The most difficult aspect of this project was balancing complexity and content. I didn't want to create a project too complext that would lack in content, but also I didn't want something with rich content that would be too simple. Therefore, I decided to create something a little more complex than Zelda. This would allow me to get creative with the content while keeping an acceptable level of complexity.

The main sources of inspiration for this project were the Zelda project and Undertale (https://store.steampowered.com/app/391540/Undertale/). I liked the interaction between the player and the environment which was showcased in Zelda, as well as the concept of moving from 1 map to the other as seen in Undertale. So, I created a project combining both.

## Implementation

After deciding on the core idea of the project, I began my research on 2D assets and ultimatelly, decided for a combination of assets taken from the following packs:
- https://game-endeavor.itch.io/mystic-woods
- https://pixel-poem.itch.io/dungeon-assetpuck
- https://jamiebrownhill.itch.io/solaria-rural-village
- https://leohpaz.itch.io/minifantasy-dungeon-sfx-pack

In order to not re-invent the wheel, I took the core event flow from Zelda and generalised it. This way, every GameObject and Entity can be made colidable and the project can easily be extended with more Quests and maps.

A unique charactersitic of the project is the player's ability to interract with objects and NPCs. Using the tools bought from the NPCs, the player can alter the environment around it by cutting trees and destroying rocks, which can be in turn sold for profit. 

The game is composed of 4 main states:
- The end-game state
- The play state
- The start state
- The story state

The end-game deals with one of the two possible outcomes: the player wins by completing all quests or it looses by loosing all its health. This creates two internal sub-states
- The GameOver sub-state
- The Victory sub-state

While playing the game, the player can toggle between multiple sub-states through interractive menus. These are:
- The Invetory sub-state
- The QuestInformation sub-state
- The Pause sub-state
- The Dialogue sub-state
- The Normal sub-state

While the first three are self-explanatory, the Dialogue sub-state is accessed whenever a player interracts with a Game Object, be it an NPC or some static object like a tree. This triggers a dialogue to appear in the bottom section and will pause the movement of all the other entities.

The normal sub-state is the default one, and it allows the player to travel between maps and interract with the world around it.

All maps use a reference to the World class which provides generic mechanisms for rendering and updating player-data. Therefore, all they do is generate the entities and objects populating the map and pass them to the generic World class.

## Conclusion

Given the above, I believe that the NPCs, the Inventory and Quest management and the support for multiple connected maps as well as support for easy extension of the game is what makes 'Quest' an unique and complex project.

