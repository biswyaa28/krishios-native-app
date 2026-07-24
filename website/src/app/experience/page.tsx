"use client";

import { useState } from "react";
import ExperienceShell from "@/components/experience/ExperienceShell";
import Scene00_DarkRoom from "@/components/experience/scenes/Scene00_DarkRoom";
import Scene01_FieldCrisis from "@/components/experience/scenes/Scene01_FieldCrisis";
import Scene02_PhoneReveal from "@/components/experience/scenes/Scene02_PhoneReveal";
import Scene03_InteractiveScan from "@/components/experience/scenes/Scene03_InteractiveScan";
import Scene04_UnderstandDiagnosis from "@/components/experience/scenes/Scene04_UnderstandDiagnosis";
import Scene05_KavyaGuidance from "@/components/experience/scenes/Scene05_KavyaGuidance";
import Scene06_ActionWorkflow from "@/components/experience/scenes/Scene06_ActionWorkflow";
import Scene07_ProductSandbox from "@/components/experience/scenes/Scene07_ProductSandbox";
import Scene08_OfflineToggle from "@/components/experience/scenes/Scene08_OfflineToggle";
import Scene09_HowKrishiOSThinks from "@/components/experience/scenes/Scene09_HowKrishiOSThinks";
import Scene10_SecurityData from "@/components/experience/scenes/Scene10_SecurityData";
import Scene11_PlatformVision from "@/components/experience/scenes/Scene11_PlatformVision";
import Scene12_Team4Brain from "@/components/experience/scenes/Scene12_Team4Brain";
import Scene13_FinalMoment from "@/components/experience/scenes/Scene13_FinalMoment";
import { DemoSample } from "@/components/experience/data/demoSamples";

export default function ExperiencePage() {
  const [activeSample, setActiveSample] = useState<DemoSample | null>(null);

  const scenes = [
    {
      id: "dark-room",
      name: "Opening",
      component: (props: { onNextScene?: () => void }) => (
        <Scene00_DarkRoom onBegin={props.onNextScene || (() => {})} />
      ),
    },
    {
      id: "field-crisis",
      name: "Field Reality",
      component: () => <Scene01_FieldCrisis />,
    },
    {
      id: "phone-reveal",
      name: "The Reveal",
      component: () => <Scene02_PhoneReveal />,
    },
    {
      id: "interactive-scan",
      name: "Interactive Scan",
      component: (props: { isLiveMode?: boolean }) => (
        <Scene03_InteractiveScan
          isLiveMode={props.isLiveMode || false}
          onSampleSelected={(sample) => setActiveSample(sample)}
        />
      ),
    },
    {
      id: "understand-diagnosis",
      name: "Diagnostic Analysis",
      component: (props: { onNextScene?: () => void }) => (
        <Scene04_UnderstandDiagnosis
          selectedSample={activeSample}
          onNextScene={props.onNextScene}
        />
      ),
    },
    {
      id: "kavya-guidance",
      name: "Kavya Advisory",
      component: (props: { onNextScene?: () => void }) => (
        <Scene05_KavyaGuidance
          selectedSample={activeSample}
          onNextScene={props.onNextScene}
        />
      ),
    },
    {
      id: "action-workflow",
      name: "Field Action",
      component: (props: { onNextScene?: () => void }) => (
        <Scene06_ActionWorkflow
          selectedSample={activeSample}
          onNextScene={props.onNextScene}
        />
      ),
    },
    {
      id: "product-sandbox",
      name: "Product Sandbox",
      component: (props: { onNextScene?: () => void }) => (
        <Scene07_ProductSandbox onReturnToStory={props.onNextScene} />
      ),
    },
    {
      id: "offline-toggle",
      name: "Remove Cloud",
      component: (props: { onNextScene?: () => void }) => (
        <Scene08_OfflineToggle onNextScene={props.onNextScene} />
      ),
    },
    {
      id: "how-krishios-thinks",
      name: "AI Neural Pipeline",
      component: (props: { onNextScene?: () => void }) => (
        <Scene09_HowKrishiOSThinks onNextScene={props.onNextScene} />
      ),
    },
    {
      id: "security-data",
      name: "Encrypted Storage",
      component: (props: { onNextScene?: () => void }) => (
        <Scene10_SecurityData onNextScene={props.onNextScene} />
      ),
    },
    {
      id: "platform-vision",
      name: "Platform Vision",
      component: (props: { onNextScene?: () => void }) => (
        <Scene11_PlatformVision onNextScene={props.onNextScene} />
      ),
    },
    {
      id: "team-4-brain",
      name: "Team 4 Brain",
      component: (props: { onNextScene?: () => void }) => (
        <Scene12_Team4Brain onNextScene={props.onNextScene} />
      ),
    },
    {
      id: "final-moment",
      name: "Narrative Closure",
      component: (props: { onResetExperience?: () => void }) => (
        <Scene13_FinalMoment onResetExperience={props.onResetExperience} />
      ),
    },
  ];

  return <ExperienceShell scenes={scenes} />;
}
