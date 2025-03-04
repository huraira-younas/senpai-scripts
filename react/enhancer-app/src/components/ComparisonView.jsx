const ComparisonView = ({ original, edited, editing }) => {
  return (
    <div className="flex flex-col md:flex-row gap-6 bg-gray-700 p-4 rounded-lg">
      <div className="flex-1 flex flex-col items-center">
        <h2 className="text-sm text-gray-300 mb-2">Original</h2>
        <img
          src={original}
          alt="Original"
          className="w-full h-auto rounded-lg border border-gray-600"
        />
      </div>

      <div className="flex-1 flex flex-col items-center relative">
        <h2 className="text-sm text-gray-300 mb-2">Edited</h2>
        <div className="relative w-full">
          {editing && (
            <div className="absolute inset-0 flex items-center justify-center bg-black bg-opacity-50 rounded-lg">
              <div className="w-12 h-12 border-4 border-blue-400 border-t-transparent rounded-full animate-spin"></div>
            </div>
          )}
          <img
            src={edited}
            alt="Edited"
            id="editor"
            className={`w-full h-auto rounded-lg border border-gray-600 ${
              editing ? "opacity-50" : ""
            }`}
          />
        </div>
      </div>
    </div>
  );
};

export default ComparisonView;
