# Melon FX's Site level environment script for Environment qL

MAPPINGS = {
        "x:" : "//mlnfs/x",
        "o:" : "//mlno/o",
        "n:" : "//mate/n",
        }

ENV_VAR_ORDER = [
        "JOB",
        "SCENE",
        "SCENE_NAME",
        "HOUDINI_TEMP_DIR",
        "LIB",
        "XRES",
        "YRES",
        "PIXEL_ASPECT",
        ]

LIB = "//mlnfs/X/Library"

# Set up job
if "job_env.py" in ENV_SCRIPTS:
    JOB = ENV_SCRIPTS["job_env.py"]
    # Scan scene OTLs under the $JOB/Asset directory
    OTL_PATTERN = JOB + "/Asset/*/Houdini/*.otl;" + JOB + "/Asset/*/Houdini/*.hda"

if "scene_env.py" in ENV_SCRIPTS:
    SCENE = ENV_SCRIPTS["scene_env.py"]
    SCENE_NAME = basename(SCENE)
else:
    SCENE_NAME = HIPNAME
    if SCENE_NAME.endswith(".hip"):
        SCENE_NAME = SCENE_NAME[:-4]
    SCENE = HIP

# Camera defaults
XRES = 1920
YRES = 1080
PIXEL_ASPECT = 1
# ARRI ALEXA
# HAPERTURE = 24.9 ---> MOD 2015.03.16
HAPERTURE = 23.8

# Scene defaults
FPS = 25
