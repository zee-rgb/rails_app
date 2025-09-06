from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI(title="AI Service")

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your Rails app's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class AnalysisRequest(BaseModel):
    text: str

class AnalysisResponse(BaseModel):
    sentiment: str
    confidence: float
    processed_text: str

@app.get("/")
async def root():
    return {"message": "AI Service is running"}

@app.post("/analyze", response_model=AnalysisResponse)
async def analyze_text(request: AnalysisRequest):
    """
    Example AI endpoint that performs sentiment analysis.
    In a real app, this would call your actual AI/ML models.
    """
    try:
        # This is a mock analysis - replace with your actual AI/ML code
        text = request.text.lower()
        
        # Simple mock sentiment analysis
        positive_words = ["good", "great", "excellent", "happy", "awesome"]
        negative_words = ["bad", "terrible", "awful", "sad", "horrible"]
        
        positive_count = sum(1 for word in positive_words if word in text)
        negative_count = sum(1 for word in negative_words if word in text)
        
        if positive_count > negative_count:
            sentiment = "positive"
            confidence = min(0.99, 0.5 + (positive_count * 0.1))
        elif negative_count > positive_count:
            sentiment = "negative"
            confidence = min(0.99, 0.5 + (negative_count * 0.1))
        else:
            sentiment = "neutral"
            confidence = 0.5
            
        return {
            "sentiment": sentiment,
            "confidence": round(confidence, 2),
            "processed_text": text.upper()  # Example text processing
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
