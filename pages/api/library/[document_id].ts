"use strict";

import { NextApiRequest, NextApiResponse } from 'next';
import { db } from "../../../db.js";
import { verify } from "jsonwebtoken";

export default async function getDocumentById(req: NextApiRequest, res: NextApiResponse) {
    if (req.method === "GET") {
        const doc_id = req.query.document_id;
        if (!doc_id) {
            res.status(500).json({ error: "No document id found" })
            return;
        }

        let email = "";
        verify(req.cookies.auth!, process.env.JWT_SECRET, async function (err, decoded) {
            if (!err && decoded?.memberEmail) email = decoded.memberEmail;
        });
        const member = await db("members").where("email",email).first();

        const doc = await db.select("documents.document_name", "documents.document_id", "documents.owner", "documents.document_description", "documents.filename", "documents.public","members.first_name", "members.last_name", "organisations.organisation_name")
            .from("documents")
            .where("documents.document_id", doc_id)
            .leftJoin("members", "documents.owner", "members.member_id")
            .leftJoin("members_organisations", "documents.owner", "members_organisations.member_id")
            .leftJoin("organisations", "members_organisations.organisation_id", "organisations.organisation_id")
            .first();

        if (!doc) {
            res.status(404).json({ error: "Document not found" })
            return;
        }

        if (!doc.public && (!member || (member.permission !== "admin" && member.member_id !== doc.owner))) {
            res.status(403).json({ error: "User is not authorised to view content" });
        }
        else {
            res.status(200).json({ doc })
        }
    }
    else {
        res.status(405).send({ error: "Method not allowed" });
    }
}