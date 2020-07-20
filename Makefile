# @author Lucas Martins Mendes
# @date dom mar 29 21:37:37 -03 2020
# This makefile is used to "automagically" keep my wallpapers organized.
# numbering and converting them.

SHELL:=/bin/bash

#Paths
WALLPAPER_PATH:="/home/luctins/Pictures/mega-images/Wallpapers"

INPUT="./input"
OUTPUT="./output"

#The categories are defined by the folder names, so to create a new category you
# only need to create a new folder
CATEGORIES:= $(shell cd $(INPUT) && ls -d */ | tr -d "/")

#Os efeitos são gerados utilizando imagemagick
EFFECTS:=spread paint

#--------------------------------------------------------------------------------
# Targets
#--------------------------------------------------------------------------------

.PHONY: $(CATEGORIES) rename all-effects help clean clean-all debug $(EFFECTS)

help:
	@echo "first run sort, to sort by categories, then apply one or more effects"
	@echo "and then run move-result to move the output to the wallpaper folder"

debug:
	@echo "Categories: $(CATEGORIES)"
	@echo "Targets: $(TARGET_FILES)" | column
	@echo "$(TARGET_PAINT)"
#	@echo "All targets: $(TARGET_FILES)" | column
#	@echo "TARGET_BLUR: $(TARGET_blur)" | column
#	@echo "TARGET_PAINT: $(TARGET_paint)" | column
#	@echo "NAME_FMT=$(NAME_FMT)"

move-result:
	@echo "Moving"
	-mv -v ./blur-output/* ./output/
	-mv -v ./paint-output/* ./output/
	-mv -v ./output/* ${WALLPAPER_PATH}

#clean-output:
#	-rm -rf ./output/*
#	-rm -rf ./blur-output/*
#	-rm -rf ./paint-output/*

clean:
	find $(INPUT) -name '*.*' -print -exec rm {} \;

#rename depends on each category, so each is built when rename is called
sort: ${CATEGORIES}
${CATEGORIES}:
	./rename-wallpaper.sh "$@" "$(INPUT)" "$(OUTPUT)" "$(WALLPAPER_PATH)"


#$(EFFECTS):
#	echo "convert -gaussian-blur 3x3 -$@ 5 -monitor -v "
#$(TARGET_SPREAD):
#	-mkdir blur-output
#	convert -gaussian-blur 10x10 -spread 10 -monitor -verbose $(shell realpath to-blur/)/$(shell echo $(basename $@) | egrep -o ^[^_]* ).jpg $(shell realpath blur-output/$@)

#$(TARGET_PAINT):
#	-mkdir paint-output
#	convert -paint 5 -monitor -verbose $(shell realpath to-paint/)/$(shell echo $(basename $@) | egrep -o ^[^_]* ).jpg $(shell realpath paint-output/$@)
