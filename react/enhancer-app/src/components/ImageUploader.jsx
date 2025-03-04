import { useRef } from "react";
import { FaUpload } from "react-icons/fa";

const ImageUploader = ({ onImageSelect, selectedImage }) => {
  const fileInputRef = useRef(null);

  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      const imageUrl = URL.createObjectURL(file);
      onImageSelect(file, imageUrl);
    }
  };

  return (
    <div className="flex flex-col items-center bg-gray-700 p-4 rounded-lg">
      <input
        type="file"
        accept="image/*"
        className="hidden"
        ref={fileInputRef}
        onChange={handleFileChange}
      />

      <button
        className="flex items-center gap-2 bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg transition"
        onClick={() => fileInputRef.current.click()}
      >
        <FaUpload /> Upload Image
      </button>

      {selectedImage && (
        <div className="mt-4 w-full max-w-xs">
          <img
            src={selectedImage}
            alt="Uploaded"
            className="w-full h-auto rounded-lg border border-gray-600"
          />
        </div>
      )}
    </div>
  );
};

export default ImageUploader;
