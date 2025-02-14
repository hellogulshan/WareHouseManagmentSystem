USE [WHMS_DB]
GO
/****** Object:  Table [dbo].[DeliveryOptions]    Script Date: 14-02-2025 6.28.22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryOptions](
	[DeliveryOptionID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryOptionName] [varchar](50) NOT NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 14-02-2025 6.28.22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderItemID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 14-02-2025 6.28.22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [date] NOT NULL,
	[CustomerName] [varchar](100) NOT NULL,
	[CustomerAddress] [varchar](255) NOT NULL,
	[DeliveryOptionID] [int] NOT NULL,
	[FulfillmentDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 14-02-2025 6.28.22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [varchar](20) NOT NULL,
	[ProductName] [varchar](100) NOT NULL,
	[WarrantyDate] [date] NULL,
	[ProductTypeID] [int] NOT NULL,
	[CurrentQuantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTypes]    Script Date: 14-02-2025 6.28.22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTypes](
	[ProductTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductTypeName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DeliveryOptions] ON 
GO
INSERT [dbo].[DeliveryOptions] ([DeliveryOptionID], [DeliveryOptionName], [IsActive]) VALUES (1, N'Standard Shipping', NULL)
GO
INSERT [dbo].[DeliveryOptions] ([DeliveryOptionID], [DeliveryOptionName], [IsActive]) VALUES (2, N'Express Shipping', NULL)
GO
INSERT [dbo].[DeliveryOptions] ([DeliveryOptionID], [DeliveryOptionName], [IsActive]) VALUES (3, N'In-Store Pickup', NULL)
GO
SET IDENTITY_INSERT [dbo].[DeliveryOptions] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderItems] ON 
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (5, 1, 21, 3)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (6, 3, 21, 2)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (7, 4, 21, 2)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (8, 6, 22, 10)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (9, 8, 22, 10)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (10, 9, 22, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (11, 10, 22, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (12, 11, 22, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (13, 12, 22, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (14, 13, 22, 2)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (15, 14, 23, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (16, 15, 23, 5)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (17, 16, 22, 8)
GO
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity]) VALUES (18, 17, 28, 30)
GO
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (1, CAST(N'2024-01-05' AS Date), N'John Doe', N'123 Main St', 1, NULL)
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (2, CAST(N'2024-01-10' AS Date), N'Jane Smith', N'456 Oak Ave', 2, NULL)
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (3, CAST(N'2025-02-13' AS Date), N'gulshan', N'dehradun', 1, CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (4, CAST(N'2025-02-13' AS Date), N'gulshan', N'dehradun', 1, CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (6, CAST(N'2025-02-13' AS Date), N'GUDDU', N'RAIPUR', 3, CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (8, CAST(N'2025-02-13' AS Date), N'GUDDU', N'RAIPUR', 3, CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (9, CAST(N'2025-02-14' AS Date), N'Alice Johnson', N'789 Park Avenue', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (10, CAST(N'2025-02-14' AS Date), N'Alice Johnson', N'789 Park Avenue', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (11, CAST(N'2025-02-14' AS Date), N'Alice Johnson', N'789 Park Avenue', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (12, CAST(N'2025-02-14' AS Date), N'Alice Johnson', N'789 Park Avenue', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (13, CAST(N'2025-02-13' AS Date), N'Sonu', N'hajipur', 1, CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (14, CAST(N'2025-02-14' AS Date), N'Himanshu', N'Gorakhpur', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (15, CAST(N'2025-02-14' AS Date), N'Anderson', N'Netherland', 2, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (16, CAST(N'2025-02-14' AS Date), N'Vikram', N'Dubai', 1, CAST(N'2025-02-21' AS Date))
GO
INSERT [dbo].[Orders] ([OrderID], [OrderDate], [CustomerName], [CustomerAddress], [DeliveryOptionID], [FulfillmentDate]) VALUES (17, CAST(N'2025-02-14' AS Date), N'David', N'Moscow', 1, CAST(N'2025-02-21' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 
GO
INSERT [dbo].[Products] ([ProductID], [ProductCode], [ProductName], [WarrantyDate], [ProductTypeID], [CurrentQuantity]) VALUES (21, N'PROD3006', N'Mithila Painting', CAST(N'2025-02-12' AS Date), 7, 16)
GO
INSERT [dbo].[Products] ([ProductID], [ProductCode], [ProductName], [WarrantyDate], [ProductTypeID], [CurrentQuantity]) VALUES (22, N'PROD1001', N'Dell Laptop', CAST(N'2024-12-31' AS Date), 1, 100)
GO
INSERT [dbo].[Products] ([ProductID], [ProductCode], [ProductName], [WarrantyDate], [ProductTypeID], [CurrentQuantity]) VALUES (23, N'PROD1002', N'Notebook', CAST(N'2025-01-15' AS Date), 2, 90)
GO
INSERT [dbo].[Products] ([ProductID], [ProductCode], [ProductName], [WarrantyDate], [ProductTypeID], [CurrentQuantity]) VALUES (24, N'PROD1003', N'T-Shirt', CAST(N'2024-10-30' AS Date), 3, 200)
GO
INSERT [dbo].[Products] ([ProductID], [ProductCode], [ProductName], [WarrantyDate], [ProductTypeID], [CurrentQuantity]) VALUES (28, N'PROD1007', N'Slippers', CAST(N'2025-03-20' AS Date), 3, 50)
GO
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductTypes] ON 
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (1, N'Electronics')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (2, N'Books')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (3, N'Clothing')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (4, N'Furniture')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (5, N'Wearables')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (6, N'AI')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (7, N'Handicraft')
GO
INSERT [dbo].[ProductTypes] ([ProductTypeID], [ProductTypeName]) VALUES (8, N'YogaStuffs')
GO
SET IDENTITY_INSERT [dbo].[ProductTypes] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Products__2F4E024F35936DC7]    Script Date: 14-02-2025 6.28.22 PM ******/
ALTER TABLE [dbo].[Products] ADD UNIQUE NONCLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeliveryOptions] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([DeliveryOptionID])
REFERENCES [dbo].[DeliveryOptions] ([DeliveryOptionID])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductTypes] ([ProductTypeID])
GO
