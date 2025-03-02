import cv2
import numpy as np
import customtkinter as ctk
from tkinter import filedialog
from PIL import Image, ImageTk
from scipy.signal import wiener

class ImageEnhancerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Advanced Image Enhancer")
        self.root.geometry("1200x700")
        ctk.set_appearance_mode("dark")
        
        self.image_path = None
        self.original_image = None
        self.processed_image = None
        self.history = []
        self.history_index = -1
        self.zoom_factor = 1.0
        
        # Sidebar
        self.sidebar = ctk.CTkFrame(self.root, width=220, height=700, corner_radius=15, fg_color="#333")
        self.sidebar.pack(side="left", fill="y", padx=10, pady=10)
        
        ctk.CTkLabel(self.sidebar, text="Image Enhancer", font=("Arial", 18, "bold"), text_color="#fff").pack(pady=10)
        
        self.upload_button = ctk.CTkButton(self.sidebar, text="📂 Upload Image", command=self.upload_image)
        self.upload_button.pack(pady=5, padx=10, fill="x")
        
        self.sharp_button = ctk.CTkButton(self.sidebar, text="🔍 Unsharp Mask", command=self.unsharp_mask)
        self.sharp_button.pack(pady=5, padx=10, fill="x")
        
        self.clahe_button = ctk.CTkButton(self.sidebar, text="🎚️ CLAHE", command=self.apply_clahe)
        self.clahe_button.pack(pady=5, padx=10, fill="x")
        
        self.deblur_button = ctk.CTkButton(self.sidebar, text="🔄 Deblur", command=self.deblur_wiener)
        self.deblur_button.pack(pady=5, padx=10, fill="x")
        
        self.denoise_button = ctk.CTkButton(self.sidebar, text="🎛️ Denoise", command=self.denoise_image)
        self.denoise_button.pack(pady=5, padx=10, fill="x")
        
        self.upscale_button = ctk.CTkButton(self.sidebar, text="⬆️ Upscale x2", command=self.upscale_image)
        self.upscale_button.pack(pady=5, padx=10, fill="x")
        
        self.undo_button = ctk.CTkButton(self.sidebar, text="↩️ Undo", command=self.undo)
        self.undo_button.pack(pady=5, padx=10, fill="x")
        
        self.redo_button = ctk.CTkButton(self.sidebar, text="↪️ Redo", command=self.redo)
        self.redo_button.pack(pady=5, padx=10, fill="x")
        
        self.reset_button = ctk.CTkButton(self.sidebar, text="🔄 Reset", command=self.reset)
        self.reset_button.pack(pady=5, padx=10, fill="x")
        
        self.save_button = ctk.CTkButton(self.sidebar, text="💾 Save Image", command=self.save_image)
        self.save_button.pack(pady=10, padx=10, fill="x")
        
        # Image Display Area with Zoom
        self.canvas = ctk.CTkCanvas(self.root, bg="#222222")
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<MouseWheel>", self.zoom)
    
    def upload_image(self):
        file_path = filedialog.askopenfilename(filetypes=[("Image Files", "*.jpg;*.png;*.jpeg")])
        if file_path:
            self.image_path = file_path
            self.original_image = cv2.imread(file_path)
            self.processed_image = self.original_image.copy()
            self.history = [self.original_image.copy()]
            self.history_index = 0
            self.display_image()
    
    def display_image(self):
        if self.processed_image is None:
            return
        
        img = cv2.cvtColor(self.processed_image, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(img)
        img = img.resize((int(img.width * self.zoom_factor), int(img.height * self.zoom_factor)), Image.Resampling.LANCZOS)
        img_tk = ImageTk.PhotoImage(img)
        self.canvas.create_image(600, 350, image=img_tk, anchor="center")
        self.canvas.image = img_tk
    
    def zoom(self, event):
        if event.delta > 0:
            self.zoom_factor *= 1.1
        else:
            self.zoom_factor *= 0.9
        self.display_image()
    
    def save_state(self):
        self.history = self.history[:self.history_index + 1]
        self.history.append(self.processed_image.copy())
        self.history_index += 1
    
    def unsharp_mask(self):
        if self.processed_image is None:
            return
        
        blurred = cv2.GaussianBlur(self.processed_image, (0, 0), 3)
        self.processed_image = cv2.addWeighted(self.processed_image, 1.5, blurred, -0.5, 0)
        self.save_state()
        self.display_image()
        
    def denoise_image(self):
        if self.processed_image is None:
            return
        
        self.processed_image = cv2.fastNlMeansDenoisingColored(self.processed_image, None, 10, 10, 7, 21)
        self.save_state()
        self.display_image()
    
    def apply_clahe(self):
        if self.processed_image is None:
            return
        
        lab = cv2.cvtColor(self.processed_image, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
        l = clahe.apply(l)
        lab = cv2.merge((l, a, b))
        self.processed_image = cv2.cvtColor(lab, cv2.COLOR_LAB2BGR)
        self.save_state()
        self.display_image()
    
    def deblur_wiener(self):
        if self.processed_image is None:
            return
        
        gray = cv2.cvtColor(self.processed_image, cv2.COLOR_BGR2GRAY)
        deblurred = wiener(gray, (5,5))
        self.processed_image = cv2.cvtColor(deblurred.astype(np.uint8), cv2.COLOR_GRAY2BGR)
        self.save_state()
        self.display_image()
    
    def upscale_image(self):
        if self.processed_image is None:
            return
        
        height, width = self.processed_image.shape[:2]
        self.processed_image = cv2.resize(self.processed_image, (width*2, height*2), interpolation=cv2.INTER_CUBIC)
        self.save_state()
        self.display_image()
    
    def undo(self):
        if self.history_index > 0:
            self.history_index -= 1
            self.processed_image = self.history[self.history_index].copy()
            self.display_image()
    
    def redo(self):
        if self.history_index < len(self.history) - 1:
            self.history_index += 1
            self.processed_image = self.history[self.history_index].copy()
            self.display_image()
    
    def reset(self):
        if self.original_image is not None:
            self.processed_image = self.original_image.copy()
            self.history = [self.original_image.copy()]
            self.history_index = 0
            self.display_image()
    
    def save_image(self):
        if self.processed_image is None:
            return
        
        file_path = filedialog.asksaveasfilename(defaultextension=".png", filetypes=[("PNG", "*.png"), ("JPEG", "*.jpg"), ("All Files", "*.*")])
        if file_path:
            cv2.imwrite(file_path, self.processed_image)

if __name__ == "__main__":
    root = ctk.CTk()
    app = ImageEnhancerApp(root)
    root.mainloop()
