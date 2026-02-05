import importlib


SKILLS = [
    ("skills.skill_trend_fetcher", "run"),
    ("skills.skill_video_metadata_ingestor", "run"),
    ("skills.skill_publish_content", "run"),
]


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

    assert not missing, "Skill interface gaps:\n" + "\n".join(missing)
