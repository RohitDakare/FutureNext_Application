-- CreateTable
CREATE TABLE "users" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "questions" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "text" TEXT NOT NULL,
    "category" TEXT,
    "emoji" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "careers" (
    "code" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "emoji" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "stream" TEXT NOT NULL,
    "salary" TEXT NOT NULL,
    "growth" TEXT NOT NULL,
    "education" TEXT NOT NULL,
    "class_11_subjects" TEXT NOT NULL,
    "riasec_codes" TEXT NOT NULL,
    "skills" TEXT NOT NULL,
    "top_colleges" TEXT NOT NULL,
    "bright_outlook" BOOLEAN NOT NULL DEFAULT false
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");
