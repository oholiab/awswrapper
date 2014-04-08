BATS=bats/bin/bats
PHONY=test
test: bats
	$(BATS) tests/*_test.bats

bats:
	git clone https://github.com/sstephenson/bats.git
