# EECE 435L Lab 10 Jenkins CI/CD

Anthony John Kanaan

The application prints `Hello, World from Anthony John Kanaan!`. This fixes the
assignment mismatch between the original implementation and personalized test.
The directory and repository use `jenkins_project`, as required by the handout
and slide 14. Slide 20's alternative `jenkins_first_last` is treated as an
example; the custom pipeline filename is `Jenkinsfile_Anthony_John_Kanaan`.

## Local execution

Use Python 3.13 (the verified Mac agent executable is
`/opt/homebrew/bin/python3.13`):

```sh
python3.13 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m flake8 app.py tests
.venv/bin/python -m unittest discover -s tests
.venv/bin/python -m pytest
.venv/bin/python -m coverage run -m pytest
.venv/bin/python -m coverage report
.venv/bin/python -m coverage html
.venv/bin/python -m bandit app.py
DEPLOY_DIR="/tmp/lab10-deployment" PYTHON_BIN="$(pwd)/.venv/bin/python" sh deploy.sh
```

`requirements.txt` lists all four required tools. `requirements-lock.txt` records
resolved versions from verification; use `-r requirements-lock.txt` to reproduce
those exact versions. No third-party packages are needed to run the deployed app.

## Jenkins job

1. Start a local Jenkins LTS controller using supported Java. This lab uses
   Java 25, bound to `127.0.0.1:8080`, with authentication enabled.
2. Install **Git**, **Pipeline** (`workflow-aggregator`), **SSH Agent**,
   **Workspace Cleanup**, **Timestamper**, and **JUnit**, including dependencies.
   SSH Agent satisfies the assignment's setup requirement; local deployment
   does not require SSH credentials.
3. Create a Pipeline job named **Python-CI-CD**. Select **Pipeline script from
   SCM**, SCM **Git**, repository
   `https://github.com/ajkanaan/jenkins_project.git`, branch `*/main`, and Script
   Path **Jenkinsfile_Anthony_John_Kanaan**. Public checkout needs no credentials.
4. Save and choose **Build Now**. The `PYTHON_BIN` parameter defaults to the
   verified Mac executable; change it when using another agent.

Stages run Setup, Lint, Test, Coverage, Security Scan, and Deploy in that order.
Commands use the virtual environment's Python directly, so POSIX `sh` does not
need Bash's `source`. Shell errors stop the stage; no failure is suppressed.
Coverage requires 100% of this small application, including its CLI entry point.
Bandit scans application source only; flake8 scans source and tests, excluding
installed dependencies. Bandit is a static check, not proof of complete security.

## Deployment and evidence

`deploy.sh` atomically installs `app.py` under
`$JENKINS_HOME/deployments/jenkins_project/`, rejects a destination within the
workspace, executes the installed file, and checks its exact output. This is a
local CLI deployment, explicitly permitted by the assignment; no web server is
needed. Run it again with `python3.13 "$JENKINS_HOME/deployments/jenkins_project/app.py"`.

Jenkins archives test, coverage, lint, installation, and security reports before
`cleanWs()` removes the workspace and virtual environment. JUnit results appear
on the build page; HTML coverage is downloadable as build artifacts. The console
log is retained by Jenkins. A brief submission report and copied genuine build
evidence accompany the submission package.

## Official references

- https://www.jenkins.io/doc/book/installing/war-file/
- https://www.jenkins.io/doc/book/platform-information/support-policy-java/
- https://www.jenkins.io/doc/pipeline/steps/ws-cleanup/
