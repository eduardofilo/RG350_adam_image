# -*- coding: utf-8 -*-
import pygame
from pygame.locals import *
import keys, settings
import logging


def render():
    # Draw background image
    background  = pygame.image.load('resources/background.png').convert()
    settings.screen.blit(background, (0, 0))
    # Draw title
    textsurface = settings.font.render("xmame . SDL . " + settings.romset, False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (33, 3))
    textsurface = settings.font.render("xmame . SDL . " + settings.romset, False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (35, 3))
    textsurface = settings.font.render("xmame . SDL . " + settings.romset, False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (33, 5))
    textsurface = settings.font.render("xmame . SDL . " + settings.romset, False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (35, 5))
    textsurface = settings.font.render("xmame . SDL . " + settings.romset, False, settings.TEXT_COLOR)
    settings.screen.blit(textsurface, (34, 4))
    # Draw ROM name
    textsurface = settings.font.render(settings.rom, False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (42, 27))
    textsurface = settings.font.render(settings.rom, False, settings.TEXT_COLOR)
    settings.screen.blit(textsurface, (41, 26))
    # Draw legend
    textsurface = settings.font.render("A:Start  B:Back  Pad:Change", False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (17, 228))
    textsurface = settings.font.render("A:Start  B:Back  Pad:Change", False, settings.TEXT_COLOR)
    settings.screen.blit(textsurface, (16, 227))
    textsurface = settings.font.render("V1.3", False, settings.SHADOW_COLOR)
    settings.screen.blit(textsurface, (286, 228))
    textsurface = settings.font.render("V1.3", False, settings.TEXT_COLOR)
    settings.screen.blit(textsurface, (285, 227))


def next_value():
    value = settings.cfgs[settings.selected]["value"]
    values = settings.cfgs[settings.selected]["values"]
    index = values.index(value)
    return values[index + 1] if index + 1 < len(values) else values[0]


def prev_value():
    value = settings.cfgs[settings.selected]["value"]
    values = settings.cfgs[settings.selected]["values"]
    index = values.index(value)
    return values[index - 1] if index > 0 else values[-1]


def save_cfg():
    f = open(settings.cfg_file, "w")
    temp_cfgs = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
    for cfg in settings.cfgs:
        if cfg["file_pos"] == 0 and cfg["value"] == 3:  # This option is incompatible with cfg
            temp_cfgs[0] = "2"                          # file so we hardcode a valid value
        else:
            temp_cfgs[cfg["file_pos"]] = str(cfg["value"])
    f.write(','.join(temp_cfgs))
    f.close()


def launch_rom():
    file = open("/tmp/run", "w")
    file.write("#!/bin/sh\n")
    file.write("cd " + "/media/data/local/share/xmame/xmame%s" % (settings.romset) + "\n")
    args = ["./xmame.SDL.%s" % (settings.romset), settings.rom]
    for cfg in settings.cfgs:
        if cfg["enabled"] and cfg["args"][cfg["value"]]:
            args.append(cfg["args"][cfg["value"]])
    cmd = " ".join(args)
    file.write(cmd)
    logging.debug(cmd)


def handle_events(events):
    for event in events:
        if event.type == pygame.KEYUP:
            if event.key == keys.RG350_BUTTON_DOWN:
                settings.selected += 1
                if settings.selected > 12:
                    settings.selected = 0
            elif event.key == keys.RG350_BUTTON_UP:
                settings.selected -= 1
                if settings.selected < 0:
                    settings.selected = 12
            if event.key == keys.RG350_BUTTON_LEFT:
                if settings.cfgs[settings.selected]["enabled"]:
                    settings.cfgs[settings.selected]["value"] = prev_value()
            elif event.key == keys.RG350_BUTTON_RIGHT:
                if settings.cfgs[settings.selected]["enabled"]:
                    settings.cfgs[settings.selected]["value"] = next_value()
            elif event.key == keys.RG350_BUTTON_A:
                save_cfg()
                launch_rom()
                settings.running = False
