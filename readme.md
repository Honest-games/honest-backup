## Docker image build and push
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t logotipiwe/debian-backuper:latest . --push
```