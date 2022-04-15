# -*- coding: utf-8 -*-
import settings
import pygame
from pygame.locals import *
import math


def render():
    n = 0
    for cfg in settings.cfgs:
        color = settings.TEXT_COLOR if cfg["enabled"] else settings.DISABLED_COLOR
        # Desc
        textsurface = settings.font.render(cfg["desc"], False, settings.SHADOW_COLOR)
        settings.screen.blit(textsurface, (42, 52+n*settings.CFG_HEIGHT))
        textsurface = settings.font.render(cfg["desc"], False, color)
        settings.screen.blit(textsurface, (41, 51+n*settings.CFG_HEIGHT))
        # Value
        if cfg["enabled"]:
            textsurface = settings.font.render(cfg["descs"][cfg["value"]], False, settings.SHADOW_COLOR)
            settings.screen.blit(textsurface, (142, 52+n*settings.CFG_HEIGHT))
            textsurface = settings.font.render(cfg["descs"][cfg["value"]], False, color)
            settings.screen.blit(textsurface, (141, 51+n*settings.CFG_HEIGHT))
        n = n + 1

    # Selection
    cursor_icon  = pygame.image.load('resources/cursor.png').convert_alpha()
    settings.screen.blit(cursor_icon, (2, 51+settings.selected*settings.CFG_HEIGHT))
