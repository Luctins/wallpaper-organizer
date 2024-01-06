# @author Lucas Martins Mendes
# @date dom mar 29 21:37:37 -03 2020
# This makefile is used to "automagically" keep my wallpapers organized.

SHELL:=/bin/bash

include Settings.inc

CFG_VARS := WALLPAPER_PATH RM_CMD TRASH_D

$(foreach var, $(CFG_VARS), $(if $($(var)),,$(error $(var) not defined)))

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
# Debug
#--------------------------------------------------------------------------------

debug:
	@echo "Categories: $(CATEGORIES)"
	@echo "Input files: $(INPUT_FILES)" | column
	@echo "Output files: $(OUTPUT_FILES)" | column
	@echo -e "cfg: \n\tdest: $(WALLPAPER_PATH), rm: $(RM_CMD), trashd: $(TRASH_D)"
#	@echo "Targets: $(TARGET_FILES)" | column
#	@echo "$(TARGET_PAINT)"
#	@echo "All targets: $(TARGET_FILES)" | column
#	@echo "TARGET_BLUR: $(TARGET_blur)" | column
#	@echo "TARGET_PAINT: $(TARGET_paint)" | column
#	@echo "NAME_FMT=$(NAME_FMT)"


#--------------------------------------------------------------------------------
# Targets
#--------------------------------------------------------------------------------

.PHONY: all help init-folders clean-input clean-output clean debug __pre-sort-hook
.PHONY: debug-eval
.PHONY: $(EFFECTS) $(INPUT_FILES) $(OUTPUT_FILES)

all: sort move-result clean


help:
	@echo "first run init-folders, then run sort, to sort by the created categories, and then"
	@echo "apply one or more effects and then run move-result to move the"
	@echo "output to the wallpaper folder"


init-folders:
	-mkdir $(INPUT)
	-mkdir $(OUTPUT)

sort: __pre-sort-hook $(INPUT_FILES)
	@echo sorting done

__pre-sort-hook:
	-rename -a ' ' '_' input/* || true

$(INPUT_FILES):
	convert -verbose "$@" "$(OUTPUT)/$(patsubst input/%/,%, $(dir $@))__$(shell date +%y-%m-%d--%H-%M-%S)__$(patsubst .%,__%,$(suffix $(shell mktemp --dry-run))).png"

move-result: $(OUTPUT_FILES)
$(OUTPUT_FILES):
	@if [[ -f "$(WALLPAPER_PATH)/$@" ]]; then echo "file collision on $@, abort"; else mv -v "$(OUTPUT)/$@" "$(WALLPAPER_PATH)/$@"; fi

#-----------------------------------------------------------
# Clean

clean: clean-input clean-output

clean-output:
	@if [ ! -z "${OUTPUT_FILES}" ]; then trash-put -v $(OUTPUT_FILES); else echo "No output files" ; fi

clean-input:
	find $(INPUT) -type f -regex ".*\.\(${INPUT_F_TYPES}\)" -exec touch {} \; -exec trash-put -v {} \;
