import { gemini15Flash, googleAI } from "@genkit-ai/googleai";
import { genkit } from "genkit";

const ai = genkit({
  plugins: [googleAI()],
  model: gemini15Flash,
});

(async () => {
  const { text } = await ai.generate({
    model: "googleai/gemini-1.5-pro-latest",
    prompt: "Invent a menu item for a pirate themed restaurant.",
  });
  console.log(text);
})();

// import * as fs from "fs";
// const pdfParse = require("pdf-parse");
// const Genkit = require("genkit-sdk");

// const genkitClient = new Genkit({
//   apiKey: "AIzaSyDkJc93zetcQaMsKQgE7OsrWELhgn4dv10",
// });

// async function extractQuestions(pdfPath: any) {
//   const dataBuffer = fs.readFileSync(pdfPath);
//   const pdfData = await pdfParse(dataBuffer);
//   const text = pdfData.text;

//   // Send text to Genkit to generate questions
//   const response = await genkitClient.generateQuestions({ content: text });
//   return response.questions;
// }

// module.exports = { extractQuestions };
