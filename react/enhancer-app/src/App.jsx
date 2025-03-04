import { useState, useRef } from "react";
import {
  FaCrop,
  FaSyncAlt,
  FaUpload,
  FaBars,
  FaTimes,
  FaMagic,
  FaTrash,
  FaUndo,
  FaRedo,
  FaSave,
} from "react-icons/fa";
import ComparisonView from "./components/ComparisonView";
import ImageUploader from "./components/ImageUploader";
import CropTool from "./components/CropTool";

function App() {
  const [processedImage, setProcessedImage] = useState(null);
  const [originalImage, setOriginalImage] = useState(null);
  const [showCropTool, setShowCropTool] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [redoStack, setRedoStack] = useState([]);
  const [loading, setLoading] = useState(false);
  const [history, setHistory] = useState([]);
  const imgRef = useRef(null);

  const handleImageSelect = (file, url) => {
    setOriginalImage(file);
    setProcessedImage(url);
    setHistory([url]);
  };

  const handleCrop = (croppedImage) => {
    setProcessedImage(croppedImage);
    setShowCropTool(false);
    updateHistory(croppedImage);
  };

  const resetImage = () => {
    setProcessedImage(URL.createObjectURL(originalImage));
    setHistory([URL.createObjectURL(originalImage)]);
    setRedoStack([]);
    setShowCropTool(false);
  };

  const enhanceImage = async () => {
    if (!processedImage) return;

    setLoading(true);

    const response = await fetch(processedImage);
    const blob = await response.blob();
    const file = new File([blob], "enhanced_image.png", { type: "image/png" });

    const formData = new FormData();
    formData.append("file", file, "enhanced_image.png");

    const apiResponse = await fetch("http://localhost:3000/enhance", {
      method: "POST",
      body: formData,
    });

    if (!apiResponse.ok) {
      console.error("Failed to enhance image:", await apiResponse.text());
      setLoading(false);
      return;
    }

    const enhancedBlob = await apiResponse.blob();
    const newImageUrl = URL.createObjectURL(enhancedBlob);
    setProcessedImage(newImageUrl);
    updateHistory(newImageUrl);
    setLoading(false);
  };

  const removeBackground = async () => {
    if (!processedImage) return;

    setLoading(true);

    const response = await fetch(processedImage);
    const blob = await response.blob();
    const file = new File([blob], "processed_image.png", { type: "image/png" });

    const formData = new FormData();
    formData.append("file", file, "processed_image.png");

    const apiResponse = await fetch("http://localhost:3000/remove-bg", {
      method: "POST",
      body: formData,
    });

    if (!apiResponse.ok) {
      console.error("Failed to process image:", await apiResponse.text());
      setLoading(false);
      return;
    }

    const bgRemovedBlob = await apiResponse.blob();
    const newImageUrl = URL.createObjectURL(bgRemovedBlob);
    setProcessedImage(newImageUrl);
    updateHistory(newImageUrl);
    setLoading(false); // ✅ Hide loader
  };

  const updateHistory = (newImage) => {
    setHistory((prev) => [...prev, newImage]);
    setRedoStack([]);
  };

  const undo = () => {
    if (history.length > 1) {
      setRedoStack((prev) => [history[history.length - 1], ...prev]);
      setHistory((prev) => prev.slice(0, -1));
      setProcessedImage(history[history.length - 2]);
    }
  };

  const redo = () => {
    if (redoStack.length > 0) {
      setProcessedImage(redoStack[0]);
      setHistory((prev) => [...prev, redoStack[0]]);
      setRedoStack((prev) => prev.slice(1));
    }
  };

  const saveImage = () => {
    if (!processedImage) return;
    const link = document.createElement("a");
    link.href = processedImage;
    link.download = "edited_image.png";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="min-h-screen bg-gray-900 text-white flex">
      <aside
        className={`fixed md:relative top-0 left-0 h-screen w-72 bg-gray-800 p-6 flex flex-col gap-4 transform ${
          sidebarOpen ? "translate-x-0" : "-translate-x-full"
        } md:translate-x-0 transition-transform duration-300 ease-in-out z-50 shadow-lg md:h-screen md:w-64`}
      >
        <div className="flex justify-between items-center mb-4">
          <h1 className="text-xl font-bold text-blue-400 flex items-center gap-2">
            <FaUpload /> Image Editor
          </h1>
          <button
            className="md:hidden text-white"
            onClick={() => setSidebarOpen(false)}
          >
            <FaTimes size={24} />
          </button>
        </div>

        <ImageUploader onImageSelect={handleImageSelect} />

        {processedImage && (
          <>
            <button className="btn" onClick={enhanceImage} disabled={loading}>
              <FaMagic /> Enhance
            </button>
            <button
              className="btn"
              onClick={() => setShowCropTool(true)}
              disabled={loading}
            >
              <FaCrop /> Crop
            </button>
            <button
              className="btn"
              onClick={removeBackground}
              disabled={loading}
            >
              <FaTrash /> Remove BG
            </button>
            <button className="btn" onClick={undo} disabled={loading}>
              <FaUndo /> Undo
            </button>
            <button className="btn" onClick={redo} disabled={loading}>
              <FaRedo /> Redo
            </button>
            <button className="btn" onClick={resetImage} disabled={loading}>
              <FaSyncAlt /> Reset
            </button>
            <button
              className="btn bg-green-500 hover:bg-green-600"
              onClick={saveImage}
              disabled={loading}
            >
              <FaSave /> Save
            </button>
          </>
        )}
      </aside>

      <main className="flex-1 flex flex-col items-center justify-center p-6">
        <button
          className="md:hidden absolute top-4 left-4 bg-gray-800 text-white p-2 rounded-lg"
          onClick={() => setSidebarOpen(true)}
        >
          <FaBars size={24} />
        </button>

        {processedImage ? (
          <>
            {showCropTool && (
              <CropTool imageSrc={processedImage} onCrop={handleCrop} />
            )}
            <ComparisonView
              original={URL.createObjectURL(originalImage)}
              edited={processedImage}
              editing={loading}
            />
          </>
        ) : (
          <p className="text-gray-400 text-center">
            Upload an image to start editing
          </p>
        )}
      </main>
    </div>
  );
}

export default App;
