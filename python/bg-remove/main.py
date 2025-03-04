from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response, JSONResponse
from fastapi import FastAPI, File, UploadFile, HTTPException
from PIL import Image, ImageEnhance
from rembg import remove
import numpy as np
import io

app = FastAPI()

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

async def process_uploaded_image(file: UploadFile):
    try:
        file_bytes = await file.read()
        image = Image.open(io.BytesIO(file_bytes)).convert("RGBA")
        return image
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid image file: {str(e)}")

# Remove Background Endpoint
@app.post("/remove-bg")
async def remove_background(file: UploadFile = File(...)):
    try:
        input_image = await process_uploaded_image(file)
        input_array = np.array(input_image)
        output_array = remove(input_array)
        
        output_image = Image.fromarray(output_array)
        img_bytes = io.BytesIO()
        output_image.save(img_bytes, format="PNG")
        img_bytes.seek(0)
        
        return Response(content=img_bytes.read(), media_type="image/png")
    
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

@app.post("/enhance")
async def enhance_image(file: UploadFile = File(...)):
    try:
        input_image = await process_uploaded_image(file)
        
        sharpness = ImageEnhance.Sharpness(input_image).enhance(1.5)
        contrast = ImageEnhance.Contrast(sharpness).enhance(1.3)
        brightness = ImageEnhance.Brightness(contrast).enhance(1.2)
        
        img_bytes = io.BytesIO()
        brightness.save(img_bytes, format="PNG", optimize=True)
        img_bytes.seek(0)
        
        return Response(content=img_bytes.read(), media_type="image/png")
    
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

# Run the server: uvicorn main:app --host 0.0.0.0 --port 3000 --reload