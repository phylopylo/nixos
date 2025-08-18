# nixos-config
My Operating System

Woo Hoo! Just got started with Nix. It's everything I ever dreamed of.

I want to separate my config into an organized file structure as much as possible. I also like the idea of having a single file I can throw in a github gist and then run my OS wherever and whenever I want by just copying and pasting the config. I would imagine the Nix language acts like gotpl or any other templating language, and that I'll be able to generate this mega config file from my organized file structure. Develop organized, deploy consolidated. It'd be neat to also add this to my rebuild script or even better, a CI script that automatically generates a gist every time a non-automated commit is pushed to the repo. Right now, I'm just working out how to configure sway using the nix options instead of the regular `.config/sway/config`, and also just configuring all my tools in general.

I have a script I used during high school through the end of undergrad to automate my arch linux install, but what I realized was that it wouldn't just be a "set it and forget it" scenario because of the variability of constantly changing packages. For Nix, I think that if I design a robust enough configuration system and I don't use any particularly niche software features, I can minimize the amount of updating my configuration will require to a great extent over the coming years. the fact that Nix is built for reproducibility gives me hope in the reliability of whatever config I converge on.

I think I'll try to convince all my friends to switch to NixOS too. It'd be sick as freak to be able to wget my config and get up and running on any available computer within seconds.
