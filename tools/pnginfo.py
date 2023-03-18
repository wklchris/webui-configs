from PIL import Image, PngImagePlugin

class InfoImage:
    def __init__(self, img_path, geninfo_key='parameters'):
        self.img = Image.open(img_path)
        self.info = self.img.info or {}
        self.geninfo = self.info.get(geninfo_key, None)
        self.save_pnginfo = None

    def update_save_info(self, new_info, replace=False):
        if replace:
            _info = new_info
        else:
            _info = self.info
            _info.update(new_info)
        
        self.save_pnginfo = PngImagePlugin.PngInfo()
        for k, v in _info.items():
            self.save_pnginfo.add_text(k, str(v))
        
    def save_img(self, fpath, quality=95):
        format = "." + fpath.split('.')[-1]
        img_format = Image.registered_extensions()[format]
        self.img.save(fpath, format=img_format, quality=quality,
                      pnginfo=self.save_pnginfo)
        print(f'{img_format} image saved: {fpath}')
