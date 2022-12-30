#!/bin/sh -x
scanimage $SCANIMAGE_OPTS | convert $CONVERT_OPTS - pdf:-
