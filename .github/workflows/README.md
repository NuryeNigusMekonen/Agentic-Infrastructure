CI runs on every push and PR.

What it does
- Builds the Docker image from Dockerfile
- Runs the container, which runs pytest inside

Expected today
- Tests are expected to fail until the skills interface is scaffolded as importable Python modules
- CI failing is acceptable for true TDD, but keep it intentional and explained in PR/README
