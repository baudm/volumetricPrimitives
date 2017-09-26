#!/bin/sh

[ $# -eq 1 ]  || exit 1

SYNSET_PATH="$1"
SYNSET="$(basename $SYNSET_PATH)"

IMAGE_DIR="../cachedir/shapenet/images/${SYNSET}"

mkdir -p $IMAGE_DIR

process() {
	name="$(basename $1)"
	png="${IMAGE_DIR}/${name}.png"
	echo $name
	[ -f "$png" ] && continue
	../renderer/render.sh `which blender` ../renderer/model.blend "${p}/model.obj" "$png"
	mogrify -crop 402x402+350+1 "$png"
	convert "$png" -colorspace gray -average "$png"
}


for p in ${SYNSET_PATH}/[0-4]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[5-8]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[9abc]*; do
	process "$p"
done &

for p in ${SYNSET_PATH}/[def]*; do
	process "$p"
done
