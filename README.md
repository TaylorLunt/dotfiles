# A collection of my dotfiles

I'm currently running Debian on my desktop with i3 and emacs. Everything that can be Solarized dark is Solarized dark.

-----

## main dotfiles
| File         | Description                                                                                                                                          |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| .Xkeymap     | Defines a few custom changes to the X keymap. Mostly make F15 a modifier key so I can use it as Hyper_R (I have it bound on my Ergodox EZ keyboard). |
| .bashrc      | Simple bash config which mostly just sets up a few aliases and adds a few things to the path.                                                        |
| .profile     | Calls .bashrc.                                                                                                                                       |
| configure.sh | A (very) work-in-progress, but eventually I want this script to completely and idempotently configure a fresh Debian install for me.                        |
| make.sh      | Makes symlinks to all of the dotfiles in this repo.                                                                                                  |

-----

## emacs stuff
| File        | Description                                                                                                                                                                                                                                                                   |
|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| init.el     | My emacs config file. I was using doom emacs, but I switched to vanilla.

-----

## scripts
| File                                          | Description                                                                                                                                   |
|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| beep.sh and toggle_beep.sh                    | Plays a sound every 15 minutes, if toggled.                                                                                                   |
| channel_id_to_rss.sh                          | Converts a YouTube channel id to its corresponding RSS feed URL.                                                                              |
| dolphin_style.qss                             | Style for the Dolphin file browser.                                                                                                           |
| empty                                         | Empties the Dolphin file browser trash.                                                                                                       |
| set-brightness-0.sh and set-brightness-100.sh | Set my monitor's brightness using DDC/CI. I run these daily with a cron job to dim my monitor at night. Better than just a blue light filter. |
| toggle_loopback.sh                            | Toggles loopback on my mic so I can hear myself through my mic.                                                                               |

-----

## awesome stuff
I used to use I3 with I3blocks, but now I'm using awesome. Blocks come from various repositories, and there are some custom blocks as well.
| File            | Description                                       |
|-----------------|---------------------------------------------------|
| rc.lua          | The main awesome config                                |
| themes/powerarrow-dark/theme.lua   | I'm using the powerarrow-dark theme from [awesome-copycats](https://github.com/lcpz/awesome-copycats), modified for a gruvbox color scheme.                               |

-----

## vivaldi css
| File        | Description                                                                                                                                               |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| vivaldi_css | css for the vivaldi web browser, which vivaldi has a [setting to load from](https://forum.vivaldi.net/topic/37802/css-modifications-experimental-feature) |
| vimium.txt  | Colemak settings for the vimium browser extension. It gives vim-like keybindings for navigation in the browser.                                                                                                                                                          |

