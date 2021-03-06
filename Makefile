.POSIX:
.SUFFIXES:

os != uname -s | tr [:upper:] [:lower:]
dotfile_dir := ./dotfile
common_dotfile_dir := $(dotfile_dir)/common
os_dotfile_dir := $(dotfile_dir)/$(os)
tmp_dir != mktemp -d -u

stow := stow --target=$(HOME) -v
unstow := stow --delete --target=$(HOME) -v

.PHONY: install
install:
	@mkdir $(tmp_dir)
	@ls $(common_dotfile_dir) > $(tmp_dir)/common-packages
	@ls $(os_dotfile_dir) > $(tmp_dir)/os-packages 2>/dev/null || true
	@cd $(common_dotfile_dir) && comm -23 $(tmp_dir)/common-packages $(tmp_dir)/os-packages | xargs -t $(stow)
	test -d $(os_dotfile_dir) && cd $(os_dotfile_dir) && $(stow) * || true
	@rm -rf $(tmp_dir)

.PHONY: uninstall
uninstall:
	cd $(common_dotfile_dir) && $(unstow) *
	test -d $(os_dotfile_dir) && cd $(os_dotfile_dir) && $(unstow) * || true

.PHONY: reinstall
reinstall: uninstall install
