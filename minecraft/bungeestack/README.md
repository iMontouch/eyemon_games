## Bungeecord network
### docker-compose.yml
* Bungeecord
* Hub
* Vanillaesqe Survival
* Factions
* MariaDB

### File Locations
Based on: "/opt/minecraft/bungeestack"

### Plugins
#### LuckPerms
Installed accross all servers. Bungeecord has its own version. To grant access to commands first time, use

`docker exec HUB_INSTANCE rcon-cli lp user USER permission set luckperms.* true`

Before changes made to the db are available on servers, they may need a simple 

`/lp sync`



### Security
#### Firewall
[Firewall Guide spigotmc.org](https://www.spigotmc.org/wiki/firewall-guide/)
