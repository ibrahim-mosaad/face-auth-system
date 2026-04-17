from insightface.app import FaceAnalysis


class FaceRecognizer:
    def __init__(self, device="cpu"):
        self.app = FaceAnalysis(name="buffalo_l")
        self.app.prepare(ctx_id=0 if device == "cuda" else -1)

    def detect_faces(self, image):
        """
        image: BGR image (OpenCV)
        return: list of detected faces
        """
        return self.app.get(image)
