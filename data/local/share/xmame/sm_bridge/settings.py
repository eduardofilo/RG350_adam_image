# -*- coding: utf-8 -*-
import sys
import os
import pygame

# Constants
SCREEN_W = 320
SCREEN_H = 240
FPS = 15
v_file  = open("v", "r")
V = v_file.readline()[:-1]
v_file.close()
TEXT_COLOR = (248, 252, 248)
DISABLED_COLOR = (128, 128, 128)
SHADOW_COLOR = (0, 0, 0)
CFG_HEIGHT = 10


# 0:  Video Rotation  0:Auto; 1:Landscape; 2:Portrait (L); 3:Portrait (R)
# 1:  Video Depth     0:Auto; 1:8-bit; 2:16-bit; 3:15-bit (RGB-Direct); 4:32-bit (RGB-Direct)
# 2:  Video Sync      0:Auto; 1:No Throttle; 2:Tripple Buffer
# 3:  Video Frameskip 0:Auto; 1:DOS; 2:Barath
# 4:  Sound           0:Auto; 1:Off
# 5:  Sound Volume    0:Auto; -32:-32; -31:-31; ... -2:-2; -1:-1
# 6:  Sound Freq      0:Auto; 1:11025; 2:22050; 3:44100
# 7:  Sound Stereo    0:Auto; 1:Off
# 8:  Save High Score 0:Auto; 1:Off
# 9:  Save state      0:None; 97:a
# 10:
# 11: Cheats          0:Off;  1:On
# 12: Speed Hack      0:Off;  1:Low; 2:Medium; 3:High
# 13: Video Rendering 0:Auto; 1:Software:No scaling; 2:H/ware:Aspect Ratio; 3:H/ware:Full Screen
# 14:


# Main data structure
cfgs = [
    {
        "file_pos": 0,
        "desc": "Video Rotation",
        "enabled": True,
        "values": [0, 1, 2, 3],
        "descs": ["Auto", "Landscape", "Portrait (L)", "Portrait (R)"],
        "args": ["-autoror", "", "-rol", "-ror"],
        "value": 0
    },
    {
        "file_pos": 13,
        "desc": "Video Rendering",
        "enabled": True,
        "values": [0, 1, 2, 3],
        "descs": ["Auto", "Software:No scaling", "H/ware:Aspect Ratio", "H/ware:Full Screen"],
        "args": ["-ipu_scaler 1", "-ipu_scaler 0", "-ipu_scaler 1", "-ipu_scaler 2"],
        "value": 0
    },
    {
        "file_pos": 1,
        "desc": "Video Depth",
        "enabled": True,
        "values": [0, 1, 2, 3, 4],
        "descs": ["Auto", "8-bit", "16-bit", "15-bit (RGB-Direct)", "32-bit (RGB-Direct)"],
        "args": ["", "-bpp 8", "-bpp 16", "-bpp 15", "-bpp 32"],
        "value": 0
    },
    {
        "file_pos": 2,
        "desc": "Video Sync",
        "enabled": True,
        "values": [0, 1, 2],
        "descs": ["Auto", "No Throttle", "Tripple Buffer"],
        "args": ["-nodirty -triplebuf", "", "-nodirty -triplebuf"],
        "value": 0
    },
    {
        "file_pos": 3,
        "desc": "Video Frameskip",
        "enabled": True,
        "values": [0, 1, 2],
        "descs": ["Auto", "DOS", "Barath"],
        "args": ["", "-frameskipper 1", "-frameskipper 2"],
        "value": 0
    },
    {
        "file_pos": 4,
        "desc": "Sound",
        "enabled": True,
        "values": [0, 1],
        "descs": ["Auto", "Off"],
        "args": ["", "-nosound"],
        "value": 0
    },
    {
        "file_pos": 5,
        "desc": "Sound Volume",
        "enabled": True,
        "values": [0, -32, -31, -30, -29, -28, -27, -26,
                   -25, -24, -23, -22, -21, -20, -19, -18,
                   -17, -16, -15, -14, -13, -12, -11, -10,
                   -9, -8, -7, -6, -5, -4, -3, -2, -1],
        "descs": ["Auto", "-32", "-31", "-30", "-29", "-28", "-27", "-26",
                  "-25", "-24", "-23", "-22", "-21", "-20", "-19", "-18",
                  "-17", "-16", "-15", "-14", "-13", "-12", "-11", "-10",
                  "-9", "-8", "-7", "-6", "-5", "-4", "-3", "-2", "-1"],
        "args": ["", "-volume -32", "-volume -31", "-volume -30",
                 "-volume -29", "-volume -28", "-volume -27", "-volume -26",
                 "-volume -25", "-volume -24", "-volume -23", "-volume -22",
                 "-volume -21", "-volume -20", "-volume -19", "-volume -18",
                 "-volume -17", "-volume -16", "-volume -15", "-volume -14",
                 "-volume -13", "-volume -12", "-volume -11", "-volume -10",
                 "-volume -9", "-volume -8", "-volume -7", "-volume -6",
                 "-volume -5", "-volume -4", "-volume -3", "-volume -2",
                 "-volume -1"],
        "value": 0
    },
    {
        "file_pos": 6,
        "desc": "Sound Freq",
        "enabled": True,
        "values": [0, 1, 2, 3],
        "descs": ["Auto", "11025", "22050", "44100"],
        "args": ["", "-samplefreq 11025", "-samplefreq 22050", "-samplefreq 44100"],
        "value": 0
    },
    {
        "file_pos": 7,
        "desc": "Sound Stereo",
        "enabled": True,
        "values": [0, 1],
        "descs": ["Auto", "Off"],
        "args": ["", "-nostereo"],
        "value": 0
    },
    {
        "file_pos": 8,
        "desc": "Save High Score",
        "enabled": True,
        "values": [0, 1],
        "descs": ["Auto", "Off"],
        "args": ["", "-hiscore_file _NONE_"],
        "value": 0
    },
    {
        "file_pos": 9,
        "desc": "Save state",
        "enabled": False,
        "values": [0],
        "descs": ["None"],
        "args": [""],
        "value": 0
    },
    {
        "file_pos": 11,
        "desc": "Cheats",
        "enabled": True,
        "values": [0, 1],
        "descs": ["Off", "On"],
        "args": ["", "-cheat"],
        "value": 0
    },
    {
        "file_pos": 12,
        "desc": "Speed Hack",
        "enabled": True,
        "values": [0, 1, 2, 3],
        "descs": ["Off", "Low", "Medium", "High"],
        "args": ["", "-speedhack 1", "-speedhack 2", "-speedhack 3"],
        "value": 0
    }
]


# Vars
running = True
selected = 0
status = 0  # 0: NORMAL
screen = None
font = None
romset = "84"
rom = "bombjack"

if 'dev' in sys.argv:
    BASEDIR = "/home/edumoreno/git/rg350_xmame_sm_bridge"
else:
    BASEDIR = "/media/data/local/share/xmame"
LOG = BASEDIR + "/sm_bridge/log.txt"

# Sample argv list: ['./main.py', '84', '/media/data/roms/ARCADE/bombjack.zip']
if len(sys.argv) > 1 and sys.argv[1] in ["52", "69", "84"]:
    romset = sys.argv[1]
if len(sys.argv) > 2:
    try:
        rom = os.path.basename(sys.argv[2]).split('.')[0]   # Rom name without extension
    except:
        pass

if 'dev' in sys.argv:
    cfg_file = BASEDIR + "/sm_bridge/%s%s.cfg" % (rom, romset)
else:
    cfg_file = BASEDIR + "/xmame%s/frontend/%s.cfg" % (romset, rom)


# cfg file creation wether it not exists
if not os.path.exists(cfg_file):
    f = open(cfg_file, "w")
    f.write("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
    f.close()

# cfg reading
f = open(cfg_file, "r")
file_cfgs = f.read().split(',')
f.close()

# Load of cfgs in file on data structure
for cfg in cfgs:
    cfg["value"] = int(file_cfgs[cfg["file_pos"]])
