import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono, Playfair_Display } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

const playfair = Playfair_Display({
  variable: "--font-playfair",
  subsets: ["latin"],
  display: "swap",
});

export const viewport: Viewport = {
  themeColor: "#F6F4ED",
  colorScheme: "light dark",
};

export const metadata: Metadata = {
  title: "KrishiOS – AI-Powered Agriculture Platform",
  description:
    "Offline-first smart agriculture platform featuring on-device ONNX edge AI crop disease diagnostics, multi-lingual Kavya voice advisory, and hardware-encrypted local storage.",
  keywords: [
    "KrishiOS",
    "Smart Agriculture",
    "AI Crop Scan",
    "Offline AI",
    "ONNX Edge AI",
    "Plant Disease Detection",
    "Flutter Agriculture App",
    "FastAPI Agronomy Gateway",
    "Kavya Voice Advisor",
    "Team 4 Brain",
  ],
  authors: [{ name: "Team 4 Brain" }],
  openGraph: {
    title: "KrishiOS – AI-Powered Agriculture Platform",
    description:
      "Empowering farmers with instantaneous, offline crop disease diagnostics and multi-lingual AI advisory.",
    url: "https://krishios.app",
    siteName: "KrishiOS",
    type: "website",
    locale: "en_US",
    images: [{ url: "/logo.png" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "KrishiOS – AI-Powered Agriculture Platform",
    description:
      "Instantaneous crop disease diagnostics powered by on-device ONNX edge AI.",
    images: ["/logo.png"],
  },
  icons: {
    icon: "/logo.png",
    shortcut: "/logo.png",
    apple: "/logo.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} ${playfair.variable} scroll-smooth h-full antialiased`}
    >
      <body className="min-h-full flex flex-col bg-[#F6F4ED] text-[#1A2919]">
        {children}
      </body>
    </html>
  );
}
