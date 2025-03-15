# Building and optimizing a Python FastAPI app with Docker (using uv)
- Docker Image + uv Optimize Setup Example.
- For testing multiple python builds / Commands / Build methods

## Command

``` powershell
docker build -f <SPECIFIC_FILE_PATH> -t test:0.0.2 .
docker run -p 8000:8000 <YOUR_IMAGE_NAME>
```

or if you want base docker version anyway (Dockerfile)
Dockerfile is same as latest version (Dockerfile.02-multi-stage-install)

``` powershell
docker build -t <YOUR_IMAGE_NAME>
docker run -p 8000:8000 <YOUR_IMAGE_NAME>
```

---

## Test Result
| Dockerfile          | Build Time | Image Size |
|---------------------|------------|------------|
| Dockerfile.01-basic | 2.1s       | 218.27MB   |
| Dockerfile.02-multi-stage-install | 4.5s       | 162.01MB   |

