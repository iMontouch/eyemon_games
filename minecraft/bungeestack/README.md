## Bungeecord network
### docker-compose.yml
* Bungeecord
* Hub
* Vanillaesqe Survival
* Factions
* MariaDB

### File Locations
Based on: "/opt/minecraft/bungeestack"

### Hub Plugins
#### DeluxeHub 3 - Professional Hub Management
[HubBasics on spigotmc.org](https://www.spigotmc.org/resources/hubbasics.2654/)

### General Plugins
#### Chat
[Venturechat on spigotmc.org](https://www.spigotmc.org/resources/venturechat.771/)
#### Spartan | Advanced Anti Cheat | Hack Blocker
[Spartan on spigotmc.org](https://www.spigotmc.org/resources/spartan-advanced-anti-cheat-hack-blocker.25638/)
#### LuckPerms
Installed accross all servers. Bungeecord has its own version. To grant access to commands first time, use

`docker exec HUB_INSTANCE rcon-cli lp user USER permission set luckperms.* true`

Before changes made to the db are available on servers, they may need a simple 

`/lp sync`

#### ExploitFixer
[ExploitFixer on spigotmc.org](https://www.spigotmc.org/resources/2ls-exploitfixer-professional-server-antiexploit.62842/)

### Security
#### Firewall
[Firewall Guide spigotmc.org](https://www.spigotmc.org/wiki/firewall-guide/)

#### Backup

