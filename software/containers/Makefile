all: development_node.def Dockerfile development_node_install.sh

development_node.def: development_node.py
	hpccm --recipe $< --format singularity > $@

Dockerfile: development_node.py
	hpccm --recipe $< --format docker > $@

development_node_install.sh: development_node.py
	hpccm --recipe $< --format bash > $@

development_node_20_04_install.sh: development_node_20_04.py
	hpccm --recipe $< --format bash > $@

clean:
	$(RM) development_node.def Dockerfile development_node_install.sh \
		development_node_20_04_install.sh
