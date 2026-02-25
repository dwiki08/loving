## 🤖 Bot Presets

This application includes several pre-configured bot presets located in `/lib/preset`:

### Available Presets

| Preset                 | Description                | Details                                                                                                                                       |
|------------------------|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **AFK IDHQ**           | Stay AFK in IDHQ house     | Automatically joins IDHQ house and moves to a customizable position (default: x:450, y:500)                                                   |
| **Battle Under B**     | Farm in BattleUnderB       | Continuously fights enemies while monitoring drops: Bone Dust, Undead Essence, Undead Energy                                                  |
| **Doom Wheel**         | Doom Wheel Spins           | Automatically handles weekly and daily Doom Wheel spins. Manages Gear of Doom items from bank and checks for Epic Item of Digital Awesomeness |
| **Nulgath B'day Farm** | Nulgath Birthday Pet Quest | Completes quest 6697 by farming items across multiple maps (Mobius, Tercessuinotlim, Hydra, Greenguard West). Tracks completion count         |
| **Supplies The Wheel** | Supplies the Wheel Quest   | Farms quest 2857 in Escherion map against Escherion boss. Monitors various Nulgath-related drops                                              |
| **Void Aura**          | Void Aura Quests           | Accepts Void Aura quests (407, 408, 409) for non-member farming                                                                               |

### Customization

Each preset extends `BasePreset` and can be configured with custom options:

- **AFK IDHQ**: Customizable X and Y position coordinates
- **Combat Presets**: Configurable skill rotation and target priority
- **Farming Presets**: Custom item drop lists and quest IDs

### Creating Custom Presets

To create your own bot preset:

1. Extend the `BasePreset` class in `/lib/preset/`
2. Implement the required methods: `name` getter, `start()`, `stop()`, and `options()`
3. Use available commands: `mapCmd`, `combatCmd`, `questCmd`, `playerCmd`, `generalCmd`
4. Register your preset provider in `/lib/services/bot_manager.dart`:

   ```dart
   // Import your preset at the top
   import '../preset/your_custom_preset.dart';

   // Add to the presets list in the build() method (line 45-52)
   final presets = [
     ref.read(doomWheelProvider),
     ref.read(nulgathBdayFarmProvider),
     ref.read(battleUnderBProvider),
     ref.read(afkIdhqProvider),
     ref.read(voidAuraProvider),
     ref.read(suppliesTheWheelProvider),
     ref.read(yourCustomPresetProvider), // Add your preset here
   ];
   ```

## 📸 Screenshots
<table>
  <tr>
    <td>
        <img src="/screenshots/1.jpg" alt="Login" />
    </td>
    <td>
        <img src="/screenshots/2.jpg" alt="Logs and Commands" />
    </td>
    <td>
        <img src="/screenshots/3.jpg" alt="Chat" />
    </td>
    <td>
        <img src="/screenshots/4.jpg" alt="Debug" />
    </td>
  </tr>
</table>