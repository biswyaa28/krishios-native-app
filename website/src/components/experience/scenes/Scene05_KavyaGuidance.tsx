"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { DemoSample, DEMO_SAMPLES } from "../data/demoSamples";
import { Volume2, Globe2, Sparkles, MessageSquare, ArrowRight } from "lucide-react";

interface Scene05Props {
  selectedSample?: DemoSample | null;
  onNextScene?: () => void;
}

export default function Scene05_KavyaGuidance({
  selectedSample,
  onNextScene,
}: Scene05Props) {
  const sample = selectedSample || DEMO_SAMPLES[0];
  const [activeLang, setActiveLang] = useState("hi");
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);

  const translations: Record<string, { name: string; native: string; text: string }> = {
    en: {
      name: "English",
      native: "English",
      text: sample.remedy,
    },
    hi: {
      name: "Hindi",
      native: "हिन्दी",
      text: "पत्तियों पर कवक संक्रमण के लक्षण हैं। 5ml नीम का तेल प्रति लीटर पानी में मिलाकर 7-10 दिनों के अंतराल पर छिड़काव करें।",
    },
    te: {
      name: "Telugu",
      native: "తెలుగు",
      text: "ఆకులపై తెగులు లక్షణాలు కనిపిస్తున్నాయి. లీటరు నీటికి 5 మి.లీ వేప నూనె కలిపి ప్రతి 7-10 రోజులకు పిచికారీ చేయండి.",
    },
    bn: {
      name: "Bengali",
      native: "বাংলা",
      text: "পাতায় ছত্রাক সংক্রমণের লক্ষণ দেখা যাচ্ছে। প্রতি লিটার জলে ৫ মিলি নিম তেল মিশিয়ে ৭-১০ দিন পরপর স্প্রে করুন।",
    },
    ta: {
      name: "Tamil",
      native: "தமிழ்",
      text: "இலைகளில் பூஞ்சை நோய் அறிகுறிகள் தெரிகின்றன. 5 மி.லி வேப்ப எண்ணெய் ஒரு லிட்டர் पाण्यात கலந்து தெளிக்கவும்.",
    },
    kn: {
      name: "Kannada",
      native: "ಕನ್ನಡ",
      text: "ಎಲೆಗಳ ಮೇಲೆ ಶಿಲೀಂಧ್ರ ರೋಗದ ಲಕ್ಷಣಗಳು ಕಂಡುಬಂದಿವೆ. ಪ್ರತಿ ಲೀಟರ್ ನೀರಿಗೆ 5 ಮಿಲಿ ಬೇವಿನ ಎಣ್ಣೆ ಬೆರೆಸಿ ಸಿಂಪಡಿಸಿ.",
    },
    mr: {
      name: "Marathi",
      native: "मराठी",
      text: "पानांवर बुरशीजन्य रोगाची लक्षणे दिसत आहेत. ५ मिली कडुनिंबाचे तेल प्रति लिटर पाण्यात मिसळून फवारणी करा.",
    },
  };

  const handlePlayAudio = () => {
    setIsPlayingAudio(true);
    if ("speechSynthesis" in window) {
      window.speechSynthesis.cancel();
      const utterance = new SpeechSynthesisUtterance(translations[activeLang].text);
      utterance.onend = () => setIsPlayingAudio(false);
      window.speechSynthesis.speak(utterance);
    } else {
      setTimeout(() => setIsPlayingAudio(false), 3000);
    }
  };

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          05 / KAVYA MULTILINGUAL ADVISORY
        </span>
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <Globe2 className="w-3.5 h-3.5" />
          <span>7 REGIONAL LANGUAGES SUPPORTED</span>
        </div>
      </div>

      {/* Main Grid Content */}
      <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 my-auto items-center">
        
        {/* Left Column: Headline & Language Selector */}
        <div className="lg:col-span-5 space-y-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="space-y-3"
          >
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#10B981]/20 text-[#10B981] text-xs font-mono">
              <Sparkles className="w-3.5 h-3.5" />
              <span>KAVYA VOICE ADVISOR</span>
            </div>

            <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
              Wisdom in Every Language.
            </h2>
            <p className="text-sm text-[#A4B8A2] font-light leading-relaxed">
              A diagnosis isn't useful if the farmer can't understand the recommendation. Select any regional language below.
            </p>
          </motion.div>

          {/* 7 Regional Language Selector Pills */}
          <div className="flex flex-wrap gap-2">
            {Object.keys(translations).map((langKey) => {
              const lang = translations[langKey];
              const isActive = activeLang === langKey;
              return (
                <button
                  key={langKey}
                  onClick={() => setActiveLang(langKey)}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                    isActive
                      ? "bg-[#10B981] text-[#0A120A] font-bold shadow-lg"
                      : "bg-[#1B2E1A] border border-[#F6F4ED]/15 text-[#A4B8A2] hover:text-[#F6F4ED] hover:border-[#F6F4ED]/30"
                  }`}
                >
                  <span>{lang.native}</span>
                  <span className="text-[10px] opacity-75 ml-1">({lang.name})</span>
                </button>
              );
            })}
          </div>

          {onNextScene && (
            <button
              onClick={onNextScene}
              className="flex items-center gap-2 text-xs font-mono text-[#10B981] hover:underline pt-4"
            >
              <span>CONTINUE TO TASK WORKFLOW</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        {/* Right Column: Localized Kavya Guidance Bubble */}
        <div className="lg:col-span-7">
          <motion.div
            key={activeLang}
            initial={{ opacity: 0, scale: 0.98 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4 }}
            className="p-8 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/40 shadow-2xl space-y-6 max-w-xl mx-auto"
          >
            <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-[#10B981] flex items-center justify-center text-[#0A120A] font-bold">
                  <MessageSquare className="w-5 h-5" />
                </div>
                <div>
                  <h4 className="font-bold text-base text-[#F6F4ED]">Kavya Regional Advisor</h4>
                  <p className="text-[10px] font-mono text-[#10B981]">
                    LOCALIZED GUIDANCE • {translations[activeLang].name.toUpperCase()}
                  </p>
                </div>
              </div>

              {/* TTS Playback Button */}
              <button
                onClick={handlePlayAudio}
                className={`p-2.5 rounded-full transition-all flex items-center gap-2 text-xs font-mono font-bold ${
                  isPlayingAudio
                    ? "bg-[#10B981] text-[#0A120A] animate-pulse"
                    : "bg-[#233B22] text-[#10B981] border border-[#10B981]/30 hover:bg-[#10B981]/20"
                }`}
              >
                <Volume2 className="w-4 h-4" />
                <span>{isPlayingAudio ? "PLAYING VOICE..." : "PLAY VOICE"}</span>
              </button>
            </div>

            {/* Translated Advisory Box */}
            <div className="p-5 rounded-2xl bg-[#0A120A] border border-[#F6F4ED]/10 space-y-2">
              <div className="text-[10px] font-mono text-[#10B981]">
                PATHOLOGY: {sample.expectedLabel}
              </div>
              <p className="text-base sm:text-xl text-[#F6F4ED] font-serif leading-relaxed">
                "{translations[activeLang].text}"
              </p>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Footer Note */}
      <div className="relative z-10 text-xs font-mono text-[#A4B8A2]/60 border-t border-[#F6F4ED]/10 pt-3">
        LOCALIZED TREATMENT GUIDANCE ACROSS 7 SUPPORTED LANGUAGES WITH TEXT-TO-SPEECH VOICE PLAYBACK
      </div>
    </div>
  );
}
