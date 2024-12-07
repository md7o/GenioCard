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

      if (!file) {
        return res.status(400).send({ error: "No file uploaded" });
      }

      // Extract text from PDF
      const pdfBuffer = Buffer.from(await fs.promises.readFile(file.path));
      const pdfData = await pdfParse(pdfBuffer);
      const pdfText = pdfData.text;

      // Use Genkit to generate questions from the text
      const { text: questions } = await ai.generate(
        `Create questions from the following text:\n\n${pdfText}`
      );
      const questionsList = questions.split("\n").filter((q) => q.trim());

      // Save questions to Firestore
      const questionsRef = firestore.collection("questions").doc();
      await questionsRef.set({ questions: questionsList });

      // Send response back to the client
      res.status(200).send({ questions: questionsList });
    } catch (error) {
      console.error("Error processing file:", error);
      res
        .status(500)
        .send({ error: "An error occurred while processing the file." });
    }
  }
);

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

// // import the Genkit and Google AI plugin libraries
// import { gemini15Flash, googleAI } from "@genkit-ai/googleai";
// import { genkit } from "genkit";
// import dotenv from "dotenv";

// // Load the API key from environment variables
// dotenv.config();

// // configure a Genkit instance
// const ai = genkit({
//   plugins: [googleAI({ apiKey: process.env.GOOGLE_GENAI_API_KEY })], // Pass the API key
//   model: gemini15Flash, // Set the model
// });

// (async () => {
//   // make a generation request
//   const { text } = await ai.generate("Say hi to ayman");
//   console.log(text);
// })();

// ============================================================================

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
