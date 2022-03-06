# @author Lucas Martins Mendes
# @date dom mar 29 21:37:37 -03 2020
# This makefile is used to "automagically" keep my wallpapers organized.

SHELL:=/bin/bash

#-------------------------------------------------------------------------------
# Settings

WALLPAPER_PATH:=/home/luctins/MEGA/Pictures/Wallpapers
TRASH_D:=/home/luctins/.local/share/Trash/

INPUT:=input
OUTPUT:=output

#-------------------------------------------------------------------------------
# The resulting file names, or "categories" are defined by the folder names, so
# to create a new category you only need to create a new folder inside $(INPUT)

#regex for input file types
INPUT_F_TYPES:=jpg\|png\|jpeg\|webp\|bmp

OUTPUT_FILES:=$(shell ls $(OUTPUT))
INPUT_FILES:= $(shell find $(INPUT) -type f -regex ".*\.\(${INPUT_F_TYPES}\)")

# The effects are generated with Imagemagick (currently Unimplemented)
EFFECTS:=spread paint blur

#--------------------------------------------------------------------------------
# Targets
#--------------------------------------------------------------------------------


.PHONY: help init-folders clean-input clean-output clean debug $(EFFECTS) $(INPUT_FILES) $(OUTPUT_FILES)

help:
	@echo "first run init-folders, then run sort, to sort by the created categories, and then"
	@echo "apply one or more effects and then run move-result to move the"
	@echo "output to the wallpaper folder"

debug:
	@echo "Categories: $(CATEGORIES)"
	@echo "Input files: $(INPUT_FILES)" | column
	@echo "Output files: $(OUTPUT_FILES)" | column
#	@echo "Targets: $(TARGET_FILES)" | column
#	@echo "$(TARGET_PAINT)"
#	@echo "All targets: $(TARGET_FILES)" | column
#	@echo "TARGET_BLUR: $(TARGET_blur)" | column
#	@echo "TARGET_PAINT: $(TARGET_paint)" | column
#	@echo "NAME_FMT=$(NAME_FMT)"

init-folders:
	mkdir $(INPUT)
	mkdir $(OUTPUT)

sort: $(INPUT_FILES)
	@echo sorting done
$(INPUT_FILES):
	convert -verbose "$@" "$(OUTPUT)/$(patsubst input/%/,%, $(dir $@))$(patsubst .%,-%,$(suffix $(shell mktemp --dry-run))).png"

move-result: $(OUTPUT_FILES)
$(OUTPUT_FILES):
	@if [[ -f "$(WALLPAPER_PATH)/$@" ]]; then echo "file collision on $@, abort"; else mv -v "$(OUTPUT)/$@" "$(WALLPAPER_PATH)/$@"; fi
#	-mv -v ./blur-output/* ./output/
#	-mv -v ./paint-output/* ./output/
#	-mv -v ./output/* ${WALLPAPER_PATH}

#-----------------------------------------------------------
# Clean

clean: clean-input clean-output

clean-output:
	-rm -rfv ./output/*
#	-rm -rf ./blur-output/*
#	-rm -rf ./paint-output/*

clean-input:
	find $(INPUT) -type f -regex ".*\.\(${INPUT_F_TYPES}\)" -exec touch {} \; -exec mv -v {} ${TRASH_D} \;
