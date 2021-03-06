"use strict";

import { NextApiRequest, NextApiResponse, NextApiHandler } from "next";
import { verify } from "jsonwebtoken";

const authenticator = (fn: NextApiHandler) => async (
    req: NextApiRequest,
    res: NextApiResponse
) => {
    const cookie = req.headers.cookie;    
    verify(cookie, process.env.JWT_SECRET, async function (err, decoded) {        
        if (!err && decoded) {

            // Do a query to check if user has anything scheduled. Use to make a countdown timer, or generally something useful.
            res.json({ context: "You are authenticated." });
            console.log("Decoded: ", decoded);
            
            return await fn(req, res);
        }
        res.status(401).json({ context: "You are not authenticated."});
    })
};

export default authenticator(async function getContext(
    req: NextApiRequest,
    res: NextApiResponse
) {});