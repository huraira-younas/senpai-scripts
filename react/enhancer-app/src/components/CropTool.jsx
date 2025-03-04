import { useRef, useEffect } from "react";
import Cropper from "cropperjs";

const CropTool = ({ imageSrc, onCrop }) => {
  const cropperRef = useRef(null);
  const imgRef = useRef(null);

  useEffect(() => {
    if (imgRef.current) {
      cropperRef.current = new Cropper(imgRef.current, {
        aspectRatio: NaN,
        autoCropArea: 1,
        viewMode: 2,
      });
    }

    return () => {
      cropperRef.current?.destroy();
    };
  }, [imageSrc]);

  const cropImage = () => {
    if (cropperRef.current) {
      const croppedDataUrl = cropperRef.current.getCroppedCanvas().toDataURL();
      onCrop(croppedDataUrl);
    }
  };

  return (
    <div className="crop-container">
      <img ref={imgRef} src={imageSrc} alt="Crop Preview" />
      <button onClick={cropImage}>Crop</button>
    </div>
  );
};

export default CropTool;
