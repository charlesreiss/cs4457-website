#!/bin/bash
mkdir -p slides
pushd ../cs4457-slides; make
cp _dist/*.pdf ../cs4457-website/slides
popd
