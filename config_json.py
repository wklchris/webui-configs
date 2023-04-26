from pathlib import Path
import json

sd_dir = Path('stable-diffusion-webui')
assert(sd_dir.is_dir())
config_fpath = sd_dir / 'config.json'

if config_fpath.is_file():
    with open(config_fpath, 'r') as f:
        j = json.load(f)
else:
    j = {}

custom_settings = {
    "save_txt": True,
    "samples_filename_pattern": "[seed]-[width]x[height]",
    "quicksettings": "sd_model_checkpoint, sd_vae, CLIP_stop_at_last_layers, samples_save, grid_save",
    "CLIP_stop_at_last_layers": 2,
    "eta_noise_seed_delta": 31337,
    "img2img_fix_steps": True,
    "enable_quantization": True
}
j.update(custom_settings)

with open(config_fpath, 'w') as f:
    json.dump(j, f, indent=4)