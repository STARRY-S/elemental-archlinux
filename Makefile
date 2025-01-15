.PHONY: image
image:
	./scripts/image.sh

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make image -- Build image"
	@echo "    make help  -- Show help"
