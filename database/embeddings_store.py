import numpy as np


class EmbeddingStore:
    def __init__(self, threshold=0.55):
        self.embeddings = []
        self.labels = []
        self.threshold = threshold

    def load(self, data: dict):
        self.embeddings = data["embeddings"]
        self.labels = data["labels"]

    def cosine_similarity(self, a, b):
        return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

    def match(self, embedding):
        if len(self.embeddings) == 0:
            return "Unknown", 0.0

        scores = [
            self.cosine_similarity(embedding, e)
            for e in self.embeddings
        ]

        best_idx = int(np.argmax(scores))
        best_score = scores[best_idx]

        if best_score >= self.threshold:
            return self.labels[best_idx], float(best_score)

        return "Unknown", float(best_score)
