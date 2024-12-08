const express = require("express");
import { Request, Response } from "express";
import fs from "fs";
import multer from "multer";
import pdfParse from "pdf-parse";
import { gemini15Flash, googleAI } from "@genkit-ai/googleai";
import { genkit } from "genkit";
import dotenv from "dotenv";
import admin from "firebase-admin";

// Initialize Firebase Admin SDK
const serviceAccount = require("../FirebaseKeys/genio-card-firebase-adminsdk-ymgn0-bf0510952c.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const firestore = admin.firestore();

// Load environment variables
dotenv.config();

// Configure Genkit
const ai = genkit({
  plugins: [googleAI({ apiKey: process.env.GOOGLE_GENAI_API_KEY })],
  model: gemini15Flash,
});

// Configure Express
const app = express();
const upload = multer({ dest: "uploads/" }); // Multer to handle file uploads

// API Endpoint to handle PDF file upload
app.post(
  "/upload-pdf",
  upload.single("pdfFile"),
  async (req: Request, res: Response) => {
    try {
      const file = req.file;
      const { numQuestions, language, difficulty } = req.body;

      if (!file) {
        return res.status(400).send({ error: "No file uploaded" });
      }

      // Extract text from PDF
      const pdfBuffer = Buffer.from(await fs.promises.readFile(file.path));
      const pdfData = await pdfParse(pdfBuffer);
      const pdfText = pdfData.text;

      // Use Genkit to generate questions from the text
      const { text: qaPairs } = await ai.generate(`
        Analyze the following text and create a JSON array with questions and answers. Use the parameters provided:
        - Number of questions: ${numQuestions}
        - Language: ${language}
        - Difficulty: ${difficulty}
        
        Input:
        ${pdfText}
        Output:
        [
          { "question": "Question 1?", "answer": "Answer 1." },
          { "question": "Question 2?", "answer": "Answer 2." }
        ]
      `);

      if (!qaPairs) {
        return res
          .status(500)
          .send({ error: "Failed to generate questions from the AI." });
      }

      // Sanitize response
      const sanitizedResponse = qaPairs.replace(/```json|```/g, "").trim();

      // Parse the JSON response
      let questionsWithAnswers;
      try {
        questionsWithAnswers = JSON.parse(sanitizedResponse);
      } catch (parseError) {
        console.error("Error parsing JSON:", parseError);
        return res.status(500).send({ error: "Invalid format in AI response" });
      }

      // Save questions to Firestore
      const questionsRef = firestore.collection("questions").doc();
      await questionsRef.set({ questions: questionsWithAnswers });

      // Send response back to the client
      res.status(200).send({ questions: questionsWithAnswers });
    } catch (error) {
      console.error("Error processing file:", error);
      res
        .status(500)
        .send({ error: "An error occurred while processing the file." });
    }
  }
);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
