failed report 
$ uv run pytest -q
F....                                         [100%]
===================== FAILURES ======================
_ test_skill_modules_exist_and_expose_run_entrypoint _

    def test_skill_modules_exist_and_expose_run_entrypoint():
        missing = []
        for module_name, fn_name in SKILLS:
            try:
                mod = importlib.import_module(module_name)
            except Exception as e:
                missing.append(f"{module_name} import failed: {e}")
                continue
    
            if not hasattr(mod, fn_name):
                missing.append(f"{module_name} missing {fn_name}()")
    
>       assert not missing, "Skill interface gaps:\n" + "\n".join(missing)
E       AssertionError: Skill interface gaps:
E         skills.skill_trend_fetcher import failed: No module named 'skills'
E         skills.skill_video_metadata_ingestor import failed: No module named 'skills'
E         skills.skill_publish_content import failed: No module named 'skills'
E       assert not ["skills.skill_trend_fetcher import failed: No module named 'skills'", "skills.skill_video_metadata_ingestor import failed: No module named 'skills'", "skills.skill_publish_content import failed: No module named 'skills'"]

tests/test_skills_interface.py:21: AssertionError
============== short test summary info ==============
FAILED tests/test_skills_interface.py::test_skill_modules_exist_and_expose_run_entrypoint - AssertionError: Skill interface gaps:
1 failed, 4 passed in 0.08s
(task3) nurye@nurye:~/Desktop/TRP1/week0/task3$ 


### why it failes 

That is happening because:

I only created the skills directory with README files

I did not create Python packages or modules yet

Pytest is correctly telling you: “the interface does not exist”

This is intentional and desired at this stage.

## docker fail
$ docker build -t chimera-task3 .
docker run --rm chimera-task3
[+] Building 51.8s (3/3) FINISHED      docker:desktop-linux
 => [internal] load build definition from Dockerfile   0.0s
 => => transferring dockerfile: 441B                   0.0s
 => ERROR [internal] load metadata for docker.io/lib  51.7s
 => [auth] library/python:pull token for registry-1.d  0.0s
------
 > [internal] load metadata for docker.io/library/python:3.12-slim:
------
Dockerfile:1
--------------------
   1 | >>> FROM python:3.12-slim
   2 |     
   3 |     WORKDIR /app
--------------------
ERROR: failed to solve: python:3.12-slim: failed to resolve source metadata for docker.io/library/python:3.12-slim: failed to copy: httpReadSeeker: failed open: failed to do request: Get "https://docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com/registry-v2/docker/registry/v2/blobs/sha256/b3/b3b92273ebb48091c16ef5f9cc1fdde40d18c7365ec38df5e9f900a2aeb3db1c/data?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=f1baa2dd9b876aeb89efebbfc9e5d5f4%2F20260205%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260205T181514Z&X-Amz-Expires=1200&X-Amz-SignedHeaders=host&X-Amz-Signature=d1897d4ada38b6a088a135016e954b2748dfed785af26cd7960ab65c0c8338e6": dialing docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com:443 container via direct connection because  has no HTTPS proxy: connecting to docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com:443: dial tcp: lookup docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com on 127.0.0.53:53: read udp 127.0.0.1:51799->127.0.0.53:53: i/o timeout

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/lh2hy8d6vf1ldzt92nxf08j1f
Unable to find image 'chimera-task3:latest' locally
docker: Error response from daemon: pull access denied for chimera-task3, repository does not exist or may require 'docker login'

Run 'docker run --help' for more information
(task3) nurye@nurye:~/Desktop/TRP1/week0/task3$ 