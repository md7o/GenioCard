// import the Genkit and Google AI plugin libraries
import { gemini15Flash, googleAI } from "@genkit-ai/googleai";
import { genkit } from "genkit";
import dotenv from "dotenv";

// Load the API key from environment variables
dotenv.config();

// configure a Genkit instance
const ai = genkit({
  plugins: [googleAI({ apiKey: process.env.GOOGLE_GENAI_API_KEY })], // Pass the API key
  model: gemini15Flash, // Set the model
});

(async () => {
  // make a generation request
  const { text } = await ai.generate("iam calling you from visual studio :)");
  console.log(text);
})();

// const express = require("express");
// import { Request, Response } from "express";
// import multer from "multer";
// import fs from "fs";
// import pdfParse from "pdf-parse";

// const app = express();
// const port = 3000;

// // Setup multer for handling file uploads
// const storage = multer.diskStorage({
//   destination: (req, file, cb) => {
//     cb(null, "uploads/"); // Folder where PDFs will be stored
//   },
//   filename: (req, file, cb) => {
//     cb(null, Date.now() + "-" + file.originalname); // Unique filename
//   },
// });

// const upload = multer({ storage: storage });

// // Route to handle PDF upload and text extraction
// app.post(
//   "/upload-pdf",
//   upload.single("pdfFile"),
//   async (req: Request, res: Response) => {
//     if (!req.file) {
//       return res.status(400).send("No file uploaded");
//     }

//     try {
//       const pdfBuffer = fs.readFileSync(req.file.path);
//       const data = await pdfParse(pdfBuffer);

//       // Here, you can generate questions from the extracted text
//       const questions = generateQuestionsFromText(data.text);

//       // Respond with generated questions
//       res.json({ questions });
//     } catch (err) {
//       console.error("Error extracting PDF content:", err);
//       res.status(500).send("Failed to extract PDF content");
//     }
//   }
// );

// // Function to generate questions from the PDF text (example)
// function generateQuestionsFromText(text: string): string[] {
//   // Implement your question generation logic here
//   // For simplicity, just split the text into sentences
//   return text.split(".").map((sentence) => `What is: ${sentence.trim()}?`);
// }

// app.listen(port, () => {
//   console.log(`Server running on http://localhost:${port}`);
// });
