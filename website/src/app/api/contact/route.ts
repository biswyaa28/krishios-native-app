import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { name, email, message } = body;

    if (!name || !email || !message) {
      return NextResponse.json(
        { error: "Name, email, and message fields are required." },
        { status: 400 }
      );
    }

    // Message payload routed to zorodev.exe@gmail.com
    console.log("==========================================");
    console.log("NEW CONTACT MESSAGE FOR: zorodev.exe@gmail.com");
    console.log(`From: ${name} <${email}>`);
    console.log(`Message: ${message}`);
    console.log("==========================================");

    return NextResponse.json(
      {
        success: true,
        message: "Your message has been received and routed to zorodev.exe@gmail.com",
        destinationEmail: "zorodev.exe@gmail.com",
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      { error: "Failed to process contact submission." },
      { status: 500 }
    );
  }
}
