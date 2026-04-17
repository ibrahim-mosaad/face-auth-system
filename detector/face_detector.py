import face_recognizer
import numpy as np
from typing import List, Tuple


class FaceDetector:
    """
    Detect faces in images
    """

    def __init__(self, model: str = "hog"):
        """
        model: 'hog' (CPU - fast)
               'cnn' (GPU - more accurate)
        """
        self.model = model

    def detect_faces(
        self, image: np.ndarray
    ) -> List[Tuple[int, int, int, int]]:
        """
        Detect faces in an image

        Returns:
            List of face locations (top, right, bottom, left)
        """
        face_locations = face_recognizer.face_locations(
            image,
            model=self.model
        )
        return face_locations

    def extract_faces(
        self, image: np.ndarray
    ) -> List[np.ndarray]:
        """
        Crop faces from image

        Returns:
            List of face images
        """
        faces = []
        locations = self.detect_faces(image)

        for (top, right, bottom, left) in locations:
            face_img = image[top:bottom, left:right]
            faces.append(face_img)

        return faces

    def detect_and_crop(
        self, image: np.ndarray
    ) -> Tuple[
        List[np.ndarray],
        List[Tuple[int, int, int, int]]
    ]:
        """
        Detect faces and return both:
        - Cropped faces
        - Face locations
        """
        locations = self.detect_faces(image)
        faces = []

        for (top, right, bottom, left) in locations:
            faces.append(image[top:bottom, left:right])

        return faces, locations
