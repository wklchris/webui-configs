# config-bayes-merger.py:
#   Quick config script for extension 'sd-webui-bayesian-merger'.
#   Test on commit: 8482999
from pathlib import Path
import yaml

# Inputs: User configured file paths
sdwebui_dir = "/path/to/stable-diffusion-webui"
model_a = "MODEL-A.safetensors"
model_b = "MODEL-B.safetensors"

# Global vars
extension_dir = f"{sdwebui_dir}/extensions/sd-webui-bayesian-merger"
conf_dir = f"{extension_dir}/conf"
payload_default = "payloadname"

if Path(extension_dir).is_dir():
    print(f"Extension dir: {extension_dir}")
else:
    raise Exception(f"Extension dir not exists: {extension_dir}")

def modify_yaml(src, dest, dicts):
    with open(src, 'r') as f:
        configs = yaml.safe_load(f)
    configs.update(dicts)

    # Replace `payload_default` with actual payload name
    if payload_default in configs:
        pname = Path(dest).stem
        configs[pname] = configs.pop(payload_default)

    with open(dest, 'w', encoding='utf-8') as f:
        yaml.dump(configs, f, sort_keys=False)

def make_payload_dict(pname, dicts):
    default_payload = {
        "prompt": "masterpiece, best quality, 1girl",
        "negative_prompt": "(worst quality, low quality:1.4), lowres, bad anatomy, (child, loli), (nsfw:1.2), (blurry), (text, logo, watermark, signature, username)",
        "steps": 20,
        "cfg": 7,
        "width": 512,
        "height": 512,
        "sampler_name": "DPM++ 2M Karras"
    }
    default_payload.update(dicts)
    pdict = {
        "src": f"{conf_dir}/payloads/cargo/payload.tmpl.yaml",
        "dest": f"{conf_dir}/payloads/cargo/{pname}.yaml",
        "dicts": {payload_default: default_payload}
    }
    return pdict

payloads = {
    "basic_girl": dict(),
    "basic_girl_768": {"height": 768}
}

bayes = {
    "config": {
        "src": f"{conf_dir}/config.tmpl.yaml",
        "dest": f"{conf_dir}/config.yaml",
        "dicts": {
            "wildcards_dir": f"{extension_dir}/wildcards",
            "scorer_model_dir": f"{extension_dir}/models",
            "model_a": f"{sdwebui_dir}/models/Stable-diffusion/{model_a}",
            "model_b": f"{sdwebui_dir}/models/Stable-diffusion/{model_b}",
            "bounds_transformer": True,
            "latin_hypercube_sampling": True,
            "batch_size": 2,  # Won't affect VRAM use
            "init_points": 5,
            "n_iters": 15,
            "scorer_method": "chad",
            "save_best": True
        }
    },
    "cargo": {
        "src": f"{conf_dir}/payloads/cargo.tmpl.yaml",
        "dest": f"{conf_dir}/payloads/cargo.yaml",
        "dicts": {
            "defaults": [{
                "cargo": list(payloads.keys())
            }],
            "enable_hr": False,
            "hr_scale": 1.5,
            "hr_upscaler": "Latent"
        }
    },
    "guide": {
        "src": f"{conf_dir}/optimisation_guide/guide.tmpl.yaml",
        "dest": f"{conf_dir}/optimisation_guide/guide.yaml",
        "dicts": dict()
    }
}

for k, v in bayes["config"]["dicts"].items():
    if k.startswith("model_") and not Path(v).is_file():
        print(f"** WARNING File not exists: '{k}' in config.yaml: {v}")

for pname, pdict in payloads.items():
    bayes[f"payloads_{pname}"] = make_payload_dict(pname, pdict)


# Main

for v in bayes.values():
    modify_yaml(**v)
