# DevOps Intern Final Assessment

**Name:** Sujo Koshy
**Date:** August 11, 2026

## Project Description

This repository is a small, end-to-end DevOps pipeline built to demonstrate practical
skills across the tools covered during the internship: Linux/scripting, Git & GitHub,
Docker, CI/CD (GitHub Actions), job orchestration with Nomad, and log monitoring with
Grafana Loki. Each step below produces a real artifact that feeds into the next step,
simulating a small but realistic DevOps workflow.

[![CI](https://github.com/sujokoshy123/devops-intern-final/actions/workflows/ci.yml/badge.svg)](https://github.com/sujokoshy123/devops-intern-final/actions/workflows/ci.yml)


---

## 1. Git & GitHub Setup

This is a public GitHub repository containing all code, configs, and documentation
for the project. The base script `hello.py` prints a simple greeting:

```python
print("Hello, DevOps!")
```

Run it with:

```bash
python3 hello.py
```

---

## 2. Linux & Scripting Basics

The `scripts/` folder contains `sysinfo.sh`, a shell script that prints:

- The current user (`whoami`)
- The current date (`date`)
- Disk usage (`df -h`)

**Make it executable and run it:**

```bash
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh
```

---

## 3. Docker Basics

The `Dockerfile` in the repo root containerizes `hello.py` using a lightweight
Python base image. On startup, the container runs `python hello.py`.

**Build the image:**

```bash
docker build -t hello-devops .
```

**Run the container:**

```bash
docker run --rm hello-devops
```

**Expected output:**

```
Hello, DevOps!
```

---

## 4. CI/CD with GitHub Actions

The workflow at `.github/workflows/ci.yml` automatically runs `hello.py` on every
push and pull request to the `main` branch, using the `actions/checkout` and
`actions/setup-python` actions. The pipeline status is shown in the badge at the
top of this README.

**Workflow steps:**
1. Checkout the repository
2. Set up Python 3.12
3. Run `python hello.py`

You can view pipeline runs under the **Actions** tab of this repository.

---

## 5. Job Deployment with Nomad

The `nomad/hello.nomad` file defines a Nomad job that runs the `hello-devops`
Docker image built in Step 3, using `type = "service"` with minimal allocated
resources (100 MHz CPU / 128 MB memory).

**Run the job (requires a running Nomad agent):**

```bash
# Start a local dev Nomad agent (in a separate terminal)
nomad agent -dev

# Validate the job file
nomad job validate nomad/hello.nomad

# Run the job
nomad job run nomad/hello.nomad

# Check status
nomad job status hello-devops

# View allocation logs
nomad alloc logs <alloc-id>
```

---

## 6. Monitoring with Grafana Loki

Log monitoring is documented in `monitoring/loki_setup.txt`, which covers:

- How Loki and Grafana were started locally via Docker
- How Promtail (`monitoring/promtail-config.yaml`) forwards Docker container
  logs (including the Nomad-run container's stdout/stderr) into Loki
- The command used to query/view logs (`logcli` and Grafana's Explore view)

**Quick start:**

```bash
docker run -d --name=loki -p 3100:3100 grafana/loki:2.9.0 -config.file=/etc/loki/local-config.yaml
docker run -d --name=grafana -p 3000:3000 grafana/grafana:latest
docker run -d --name=promtail \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v $(pwd)/monitoring/promtail-config.yaml:/etc/promtail/config.yml \
  grafana/promtail:2.9.0 -config.file=/etc/promtail/config.yml
```

Then open Grafana at `http://localhost:3000`, add Loki (`http://localhost:3100`)
as a data source, and query `{job="containerlogs"}` under **Explore**.

_(Screenshots of the Grafana Explore view can be added here.)_

---

## 7. Extra Credit (Optional)

Not attempted in this submission. Potential future additions:
- `mlflow/` — log a dummy MLflow experiment
- `vm/` — deploy a VirtualBox VM and run the Docker/Nomad job inside it

---

## Repository Structure

```
devops-intern-final/
├── README.md
├── hello.py
├── Dockerfile
├── scripts/
│   └── sysinfo.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── nomad/
│   └── hello.nomad
└── monitoring/
    ├── loki_setup.txt
    └── promtail-config.yaml
```
