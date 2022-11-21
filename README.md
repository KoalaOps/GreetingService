### Build and run locally:

1. Generate proto:

    ``` make proto ```

2. Build:
    
    ``` make build ```

3. Run:

    ``` ./bin/greeting ```
    or
    ``` go run server/server.go ```

### Build Docker image:

1.  Build:

    ``` 
    TAG=latest 
    REPO_PREFIX=us-central1-docker.pkg.dev/<PROJECT_ID>/<repo-name>
    image="${REPO_PREFIX}/greetingservice:$TAG"
    docker build --platform linux/amd64 -t "${image}" .
    ```

2. Push: ``` docker push "${image}" ```

### Deploy:

Update project ID and repo name in k8s/manifest.yaml, then 
``` kubectl apply -f k8s/manifest.yaml ```