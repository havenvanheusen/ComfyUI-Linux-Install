# ComfyUI-linux-Install
A simple script to make installing ComfyUI on Linux easier. This fork is intended solely as an installation script. It will create a new script (start.sh) in the chosen directory to update and launch ComfyUI once you've installed it.

**Note that this script uses relative paths. I had no reason to change that so I left it as is, but just a heads up if you're running the script from another working directory.**

Step 1) download the **comfy-webui.sh** file to your home directory.

Step 2) Open a terminal window and execute the next 2 commands.

**chmod +x comfy-webui.sh**  <<-- set the executable permission

**./comfy-webui.sh**  <<--  execute the script

Step 3) Lastly, after the script finishes, Press _Ctrl-C_ to quit.

Step 4) Download models and place the files in the _ComfyUI/models/checkpoints_ or _ComfyUI/models/unet_ directories and VAE files in the _ComfyUI/models/vae_ directory as normal. These can be found in a variety of places like civitai.com, huggingface.co, etc.

Step 5) Any time you wish to start the server, in your home directory, simply start **./start.sh**.

ComfyUI Github Repository: https://github.com/comfyanonymous/ComfyUI

By using the **start.sh** script this creates to start the ComfyUI AI, your copy of ComfyUI will be automatically
updated to the latest version of ComfyUI.

I wanted a script that would mostly automate the creation of a new ComfyUI instance in order to combat dependency conflicts by having instances depending on purpose (Image generation, inpainting, video generation, 3D mesh generation, background removal, etc.) and test new nodes/workflows/updates without breaking an existing installation.
