-- *******************************************************************
-- Initialize empty Drugs@FDA database, using table format defined at:
-- http://www.fda.gov/Drugs/InformationOnDrugs/ucm079750.htm
-- @retrieved 2013-2-5
-- @author Jason Alan Fries
-- @email jason-fries [at] uiowa.edu
-- *******************************************************************

-- Application Documents (AppDoc): 
-- Document addresses or URLs to letters, labels, reviews, 
-- Consumer Information Sheets, FDA Talk Papers, and other types.

CREATE TABLE AppDoc (
		AppDocID INTEGER NOT NULL,
		ApplNo VARCHAR(6) NOT NULL,
		SeqNo VARCHAR(4) NOT NULL,
		DocType VARCHAR(50) NOT NULL,
		DocTitle VARCHAR(100),
		DocURL VARCHAR(200),
		DocDate DATE,
		ActionType VARCHAR(10) NOT NULL,
		DuplicateCounter INTEGER,
		PRIMARY KEY(AppDocID) );
		
-- Application Document Type Lookup (AppDocType_Lookup): 
-- Type of document that is linked, which relates to the AppDoc table.
CREATE TABLE AppDocType_Lookup (
		AppDocType VARCHAR(50) PRIMARY KEY,
		SortOrder INTEGER);

-- Application (Application): 
-- Application number and sponsor name.
CREATE TABLE Application (
		ApplNo VARCHAR(6) PRIMARY KEY,
		ApplType VARCHAR(5),
		SponsorApplicant VARCHAR(50) NOT NULL,
		MostRecentLabelAvailableFlag BIT NOT NULL,
		CurrentPatentFlag BIT NOT NULL,
		ActionType VARCHAR(10) NOT NULL,
		Chemical_Type VARCHAR(3),
		Therapeutic_Potential VARCHAR(2),
		Orphan_Code VARCHAR(1) );

-- Document Type Lookup (DocType_Lookup): 
-- Supplement type code and description to the application number.
CREATE TABLE DocType_Lookup (
		DocType VARCHAR(4) PRIMARY KEY,
		DocTypeDesc VARCHAR(50) );
											
-- Product (Product): 
-- This table contains the products included in each application. 
-- Includes form, dosage, and route.
CREATE TABLE Product (
		ApplNo VARCHAR(6) NOT NULL,
		ProductNo VARCHAR(3) NOT NULL,
		Form VARCHAR(255) NOT NULL,
		Dosage VARCHAR(240) NOT NULL,
		ProductMktStatus INTEGER NOT NULL,
		TECode VARCHAR(100),
		ReferenceDrug BIT NOT NULL,
		Drugname VARCHAR(125),
		Activeingred VARCHAR(255),
		PRIMARY KEY(ApplNo, ProductNo, Form, Dosage, ProductMktStatus) ); 

-- Product_TECode: Therapeutic Equivalence Code for Products.
CREATE TABLE Product_TECode (
		ApplNo VARCHAR(6) NOT NULL,
		ProductNo VARCHAR(3) NOT NULL,
		TECode VARCHAR(50) NOT NULL,
		TESequence INTEGER NOT NULL,
		ProdMktStatus INTEGER NOT NULL,
		PRIMARY KEY(ApplNo, ProductNo, TESequence, ProdMktStatus) );

-- Supplements (RegActionDate): 
-- Approval history for each application. Includes supplement 
-- number and dates of approval.
CREATE TABLE RegActionDate (
		ApplNo VARCHAR(6) NOT NULL,
		ActionType VARCHAR(10) NOT NULL,
		InDocTypeSeqNo VARCHAR(4) NOT NULL,
		DuplicateCounter INTEGER NOT NULL,
		ActionDate DATE,
		DocType VARCHAR(4),
		PRIMARY KEY(ApplNo, InDocTypeSeqNo, DuplicateCounter) );

-- ChemicalType_Lookup
CREATE TABLE ChemicalType_Lookup (
		ChemicalTypeID INTEGER PRIMARY KEY,
		ChemicalTypeCode VARCHAR(3) NOT NULL,
		ChemicalTypeDescription VARCHAR(200) NOT NULL);

-- ReviewClass_Lookup
CREATE TABLE ReviewClass_Lookup (
		ReviewClassID INTEGER NOT NULL,
		ReviewCode VARCHAR(1) NOT NULL,
		LongDescritption VARCHAR(100),
		ShortDescription VARCHAR(100) NOT NULL,
		PRIMARY KEY(ReviewClassID) );