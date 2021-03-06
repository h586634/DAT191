"use strict";

import { NextApiRequest, NextApiResponse } from "next";
import { db } from "../../../db";
import { getMemberClaims } from "../../../utils/server/user";
import { INTERNAL_SERVER_ERROR, METHOD_NOT_ALLOWED } from "../../../messages/apiResponse";

export default async function getDocuments(req: NextApiRequest, res: NextApiResponse) {
    if (req.method === "GET") {
        const cookie = req.cookies.auth;
        const { id, permission } = getMemberClaims(cookie);

        try {
            if (permission === "admin") {
                const documents = await db.select("documents.document_name", "documents.document_description", "documents.document_id", "members.first_name", "members.last_name", "organisations.organisation_name")
                .from("documents")
                .leftJoin("members", "documents.owner", "members.member_id")
                .leftJoin("members_organisations", "documents.owner", "members_organisations.member_id")
                .leftJoin("organisations", "members_organisations.organisation_id", "organisations.organisation_id")
                .distinctOn("documents.document_name")
                .orderBy("documents.document_name", "asc");
                res.status(200).json(documents);
            }
            else {
                const documents = await db.select("documents.document_name", "documents.document_description", "documents.document_id", "members.first_name", "members.last_name", "organisations.organisation_name")
                .from("documents")
                .leftJoin("members", "documents.owner", "members.member_id")
                .leftJoin("members_organisations", "documents.owner", "members_organisations.member_id")
                .leftJoin("organisations", "members_organisations.organisation_id", "organisations.organisation_id")
                .where("public", true).orWhere("owner", id)
                .distinctOn("documents.document_name")
                .orderBy("documents.document_name", "asc");
                res.status(200).json(documents);
            }
        }
        catch (error) {
            console.error(error);
            res.status(500).json(INTERNAL_SERVER_ERROR);
        }
    }
    else {
        res.status(405).json(METHOD_NOT_ALLOWED);
    }
}