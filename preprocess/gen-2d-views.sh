#!/bin/sh

[ $# -eq 1 ]  || exit 1

SYNSET_PATH="$1"
SYNSET="$(basename $SYNSET_PATH)"

IMAGE_DIR="../cachedir/shapenet/images/${SYNSET}"

mkdir -p $IMAGE_DIR

process() {
	path="$1"
	name="$(basename $path)"
	png="${IMAGE_DIR}/${name}.png"
	echo $name
	[ -f "$png" ] && continue
	../renderer/render.sh `which blender` ../renderer/model.blend "${path}/model.obj" "$png"
	mogrify -crop 402x402+350+1 "$png"
	convert "$png" -colorspace gray -average "$png"
}

# Parallel processing using 4 threads

for p in ${SYNSET_PATH}/[0-4]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[5-8]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[9abc]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[defu]*; do
	process "$p"
done
