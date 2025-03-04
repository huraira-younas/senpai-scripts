from fastapi.middleware.cors import CORSMiddleware 
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import Response
from PIL import Image, ImageEnhance
from rembg import remove
import io

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/remove-bg")
async def remove_background(file: UploadFile = File(...)):
    try:
        input_image = Image.open(io.BytesIO(await file.read())).convert("RGBA")
        output_image = remove(input_image)

        img_bytes = io.BytesIO()
        output_image.save(img_bytes, format="PNG")
        img_bytes.seek(0)

        return Response(content=img_bytes.read(), media_type="image/png")
    except Exception as e:
        return {"error": str(e)}
    
    
@app.post("/enhance")
async def enhance_image(file: UploadFile = File(...)):
    try:
        input_image = Image.open(io.BytesIO(await file.read())).convert("RGBA")

        # Enhance the image: Adjust sharpness, contrast, and brightness
        sharpness = ImageEnhance.Sharpness(input_image).enhance(1.5)
        contrast = ImageEnhance.Contrast(sharpness).enhance(1.3)
        brightness = ImageEnhance.Brightness(contrast).enhance(1.2)

        img_bytes = io.BytesIO()
        brightness.save(img_bytes, format="PNG", optimize=True)
        img_bytes.seek(0)

        return Response(content=img_bytes.read(), media_type="image/png")
    except Exception as e:
        return {"error": str(e)}

# Run the server: uvicorn main:app --host 0.0.0.0 --port 3000 --reload
