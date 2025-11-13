.PHONY: all
all:
	@echo hello

./LSColors/bin/Release/net10.0/LSColors.dll: $(wildcard ./LSColors/*.cs)
	dotnet build -c Release

git-hook-post-update: ./LSColors/bin/Release/net10.0/LSColors.dll, $(wildcard ./_/**/*)
	pwsh -nop -c ./scripts/dotfiles.ps1

.PHONY: git-prepare
git-prepare:
	@echo make git-hook-post-update > ./.git/hooks/post-update
	@chmod +x ./.git/hooks/post-update
