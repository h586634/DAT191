"use strict";

import Link from "next/link";
import { useRef, useState } from "react";
import Header from "../../components/header";


export default function Login({isCookie}) {
  const emailRef = useRef<HTMLInputElement>(null);
  const passRef = useRef<HTMLInputElement>(null);
  const [message, setMessage] = useState<any>(null);

  async function handleForm() {
    const respt = await fetch("http://localhost:3000/api/user/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: emailRef.current?.value,
        password: passRef.current?.value,
      }),
    });

    const json = await respt.json();
    setMessage(json);

    // FOR TESTING!!
    console.log(message);
  }

  return (
    <>
      {Header(isCookie)}
      <main>
        <div className="main-content">
          <input
            type="email"
            name="email"
            placeholder="Your email address"
            ref={emailRef}
          />
        </div>
        <div>
          <input
            type="password"
            name="password"
            placeholder="Your password"
            ref={passRef}
          />
        </div>
        <button className="submit-button" onClick={handleForm}>
          Submit
        </button>
        <hr />
        <Link href="/register">
          <a>Create Account</a>
        </Link>
      </main>
    </>
  );
}

export async function getServerSideProps(appContext) {
  const cookie = appContext.req?.headers.cookie;

  const isCookie = cookie ? true : false;
  return { props: { isCookie } };
}