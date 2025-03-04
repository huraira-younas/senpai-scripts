import { useRef } from "react";
import Cropper from "react-cropper";
import "cropperjs/dist/cropper.css";

const CropTool = ({ imageSrc, onCrop }) => {
  const cropperRef = useRef(null);
  const cropImage = () => {
    const cropper = cropperRef.current?.cropper;
    onCrop(cropper.getCroppedCanvas().toDataURL());
  };

  return (
    <div>
      <Cropper
        style={{ height: 400, width: "100%" }}
        initialAspectRatio={16 / 9}
        ref={cropperRef}
        src={imageSrc}
        guides={false}
      />
      <button className="w-full m-6" onClick={cropImage}>
        Crop
      </button>
    </div>
  );
};

export default CropTool;
