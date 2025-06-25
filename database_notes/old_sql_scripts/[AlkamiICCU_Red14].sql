USE [AlkamiICCU_Red14]
GO

EXEC [AlkamiICCU_Red14].sys.sp_dropextendedproperty @name=N'SQLSourceControl Scripts Location' 
GO

EXEC [AlkamiICCU_Red14].sys.sp_dropextendedproperty @name=N'SQLSourceControl Database Revision' 
GO

EXEC [AlkamiICCU_Red14].sys.sp_dropextendedproperty @name=N'MS_Description' 
GO

USE [master]
GO

/****** Object:  Database [AlkamiICCU_Red14]    Script Date: 1/24/2024 9:04:12 AM ******/
DROP DATABASE [AlkamiICCU_Red14]
GO

/****** Object:  Database [AlkamiICCU_Red14]    Script Date: 1/24/2024 9:04:12 AM ******/
CREATE DATABASE [AlkamiICCU_Red14]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Primary_Data', FILENAME = N'D:\Databases\AlkamiICCU_Red14.mdf' , SIZE = 15704064KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
 LOG ON 
( NAME = N'Log', FILENAME = N'E:\Logs\AlkamiICCU_Red14.ldf' , SIZE = 1436672KB , MAXSIZE = 2048GB , FILEGROWTH = 1048576KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AlkamiICCU_Red14].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ARITHABORT OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET  DISABLE_BROKER 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET AUTO_UPDATE_STATISTICS_ASYNC ON 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET READ_COMMITTED_SNAPSHOT ON 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET  MULTI_USER 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [AlkamiICCU_Red14] SET DB_CHAINING OFF 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [AlkamiICCU_Red14] SET ENCRYPTION ON
GO

ALTER DATABASE [AlkamiICCU_Red14] SET QUERY_STORE = OFF
GO

USE [AlkamiICCU_Red14]
GO

EXEC [AlkamiICCU_Red14].sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The underlying datastore for the Alkami ORB Platform, containing all the protected financial information for users, accounts, and transactions, as well as configuration information for financial institutions to support an instance of the database tier of the application' 
GO

EXEC [AlkamiICCU_Red14].sys.sp_addextendedproperty @name=N'SQLSourceControl Database Revision', @value=3359 
GO

EXEC [AlkamiICCU_Red14].sys.sp_addextendedproperty @name=N'SQLSourceControl Scripts Location', @value=N'<?xml version="1.0" encoding="utf-16" standalone="yes"?>
<ISOCCompareLocation version="1" type="TfsLocation">
  <ServerUrl>http://tfs:8080/tfs/alkamicollection</ServerUrl>
  <SourceControlFolder>$/Alkami/Dev/Database/Alkami.Dev</SourceControlFolder>
</ISOCCompareLocation>' 
GO

USE [master]
GO

ALTER DATABASE [AlkamiICCU_Red14] SET  READ_WRITE 
GO


