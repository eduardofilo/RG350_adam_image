#!/usr/bin/env python
# -*- coding: utf-8 -*-
import settings, app, screen, keys
import sys
import logging
import pygame
from pygame.locals import *


# Initialization
logging.basicConfig(level=logging.ERROR, filename=settings.LOG, filemode="a+", format="%(asctime)-15s %(levelname)-8s %(message)s")
successes, failures = pygame.init()
logging.debug("{0} successes and {1} failures".format(successes, failures))
pygame.font.init()

clock = pygame.time.Clock()
pygame.mouse.set_visible(False)
realScreen = pygame.display.set_mode((settings.SCREEN_W,settings.SCREEN_H), HWSURFACE, 16)
settings.screen = pygame.Surface((settings.SCREEN_W,settings.SCREEN_H))
settings.font = pygame.font.Font('resources/pixelberry.ttf', 8)

logging.debug("romset: " + settings.romset)
logging.debug("ROM: " + settings.rom)
logging.debug("cfg :" + settings.cfg_file)


# Main loop
dt = 1 / settings.FPS * 1000     # dt is the time since last frame.
dirty = True
while settings.running:
    # Event management
    events = pygame.event.get()
    for event in events:
        dirty = True
        if event.type == pygame.QUIT:
            settings.running = False
        if event.type == pygame.KEYUP:
            if event.key in [keys.RG350_BUTTON_B, keys.RG350_BUTTON_SELECT]:
                settings.running = False

    app.handle_events(events)

    if dirty:
        app.render()
        screen.render()
        realScreen.blit(settings.screen, (0,0))
        pygame.display.flip()
        dirty = False

    dt = clock.tick(settings.FPS)

pygame.quit()
sys.exit()
quit()
