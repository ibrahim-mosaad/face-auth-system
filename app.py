import cv2
import pickle
import numpy as np
from fastapi import FastAPI, UploadFile, File

from recognition.face_recognizer import FaceRecognizer
from database.embeddings_store import EmbeddingStore
from utils.image_utils import encode_image


app = FastAPI(title="Face Recognition API")

# -------------------------
# Load Face Recognizer
# -------------------------
recognizer = FaceRecognizer(device="cpu")

# -------------------------
# Load Embeddings Database
# -------------------------
with open("database/embeddings.pkl", "rb") as f:
    data = pickle.load(f)

store = EmbeddingStore(threshold=0.55)
store.load(data)

# -------------------------
# API Endpoint
# -------------------------
@app.post("/recognize")
async def recognize_face(file: UploadFile = File(...)):
    contents = await file.read()
    np_img = np.frombuffer(contents, np.uint8)
    image = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    if image is None:
        return {"error": "Invalid image"}

    faces = recognizer.detect_faces(image)
    results = []

    for face in faces:
        x1, y1, x2, y2 = face.bbox.astype(int)
        name, score = store.match(face.embedding)

        # Draw result
        cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
        cv2.putText(
            image,
            f"{name} ({score:.2f})",
            (x1, y1 - 10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0, 255, 0),
            2
        )

        results.append({
            "name": name,
            "score": score
        })

    return {
        "faces": results,
        "image": encode_image(image)
    }
