all:
	make_all.py

clean:
	rm -rf stls assemblies bom deps dxfs
	rm -f *.html *.md *.scad *.png openscad.*

add:
	git add \
	  stls/*.png stls/*.stl \
	  assemblies/*.png \
	  bom/*.txt bom/*.json bom/*.csv \
	  dxfs/*.dxf dxfs/*.png \
	  stls/bounds.json \
	  readme.* printme.html
