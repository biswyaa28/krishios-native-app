"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { DemoSample, DEMO_SAMPLES } from "../data/demoSamples";
import { CheckSquare, Calendar, Bell, ArrowRight, PlusCircle, CheckCircle2 } from "lucide-react";

interface Scene06Props {
  selectedSample?: DemoSample | null;
  onNextScene?: () => void;
}

export default function Scene06_ActionWorkflow({
  selectedSample,
  onNextScene,
}: Scene06Props) {
  const sample = selectedSample || DEMO_SAMPLES[0];
  const [taskAdded, setTaskAdded] = useState(false);

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          06 / FIELD ACTION WORKFLOW
        </span>
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <CheckSquare className="w-3.5 h-3.5" />
          <span>USER-INITIATED TASK SCHEDULING</span>
        </div>
      </div>

      {/* Main Grid Content */}
      <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 my-auto items-center">
        
        {/* Left Column: Headline & Action Button */}
        <div className="lg:col-span-5 space-y-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="space-y-3"
          >
            <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
              Turn Advice into Action.
            </h2>
            <p className="text-sm text-[#A4B8A2] font-light leading-relaxed">
              Detection tells you what happened. KrishiOS lets the farmer turn recommendations into actionable work with a single tap.
            </p>
          </motion.div>

          {/* Interactive Button */}
          <div className="pt-2">
            <button
              onClick={() => setTaskAdded(true)}
              className={`px-6 py-3.5 rounded-2xl font-mono text-xs font-bold transition-all flex items-center gap-2 shadow-xl ${
                taskAdded
                  ? "bg-[#10B981] text-[#0A120A] ring-2 ring-[#10B981]/50"
                  : "bg-[#233B22] border border-[#10B981] text-[#10B981] hover:bg-[#10B981] hover:text-[#0A120A]"
              }`}
            >
              {taskAdded ? (
                <>
                  <CheckCircle2 className="w-4 h-4" />
                  <span>TASK ADDED TO WORKSTATION CALENDAR</span>
                </>
              ) : (
                <>
                  <PlusCircle className="w-4 h-4" />
                  <span>ADD RECOMMENDED TREATMENT TO TASKS</span>
                </>
              )}
            </button>
          </div>

          {onNextScene && (
            <button
              onClick={onNextScene}
              className="flex items-center gap-2 text-xs font-mono text-[#10B981] hover:underline pt-4"
            >
              <span>CONTINUE TO REAL PRODUCT SANDBOX</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        {/* Right Column: Scheduled Task Card Card */}
        <div className="lg:col-span-7">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.6 }}
            className="p-6 sm:p-8 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/40 shadow-2xl space-y-6 max-w-xl mx-auto"
          >
            <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
                  <CheckSquare className="w-5 h-5" />
                </div>
                <div>
                  <h4 className="font-bold text-base text-[#F6F4ED]">Foliage Spray Protocol</h4>
                  <p className="text-[10px] font-mono text-[#10B981]">SCHEDULER ENGINE</p>
                </div>
              </div>

              <span className={`px-2.5 py-1 rounded-full text-[10px] font-mono font-bold ${
                taskAdded ? "bg-[#10B981] text-[#0A120A]" : "bg-[#F6F4ED]/10 text-[#A4B8A2]"
              }`}>
                {taskAdded ? "SCHEDULED" : "PENDING"}
              </span>
            </div>

            <div className="space-y-4 text-xs text-[#A4B8A2]">
              <div className="p-4 rounded-2xl bg-[#0A120A] border border-[#F6F4ED]/10 space-y-1">
                <div className="text-[10px] font-mono text-[#10B981]">TARGET CROP & PATHOLOGY</div>
                <div className="text-[#F6F4ED] font-bold text-sm">{sample.cropName} • {sample.expectedLabel}</div>
              </div>

              <div className="grid grid-cols-2 gap-3 font-mono text-[11px]">
                <div className="p-3 rounded-xl bg-[#0A120A] border border-[#F6F4ED]/10 flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-[#10B981]" />
                  <span>DUE: IN 3 DAYS</span>
                </div>

                <div className="p-3 rounded-xl bg-[#0A120A] border border-[#F6F4ED]/10 flex items-center gap-2">
                  <Bell className="w-4 h-4 text-[#10B981]" />
                  <span>PRIORITY: HIGH</span>
                </div>
              </div>

              <div className="p-4 rounded-2xl bg-[#0A120A] border border-[#F6F4ED]/10 space-y-1">
                <div className="text-[10px] font-mono text-[#10B981]">ACTION ITEM</div>
                <p className="text-[#F6F4ED] leading-relaxed">{sample.remedy}</p>
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Footer Note */}
      <div className="relative z-10 text-xs font-mono text-[#A4B8A2]/60 border-t border-[#F6F4ED]/10 pt-3">
        USER-INITIATED TASK SCHEDULING INTEGRATED IN FRONTEND TASKS WORKSTATION
      </div>
    </div>
  );
}
