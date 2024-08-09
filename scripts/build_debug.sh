#!/usr/bin/env bash

odin build main_release -define:GameProfile=true -define:DEV_MODE=true -out:game_debug.bin -no-bounds-check -debug
