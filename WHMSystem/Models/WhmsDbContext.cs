using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace WHMSystem.Models;

public partial class WhmsDbContext : DbContext
{
    public WhmsDbContext()
    {
    }

    public WhmsDbContext(DbContextOptions<WhmsDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<DeliveryOption> DeliveryOptions { get; set; }

    public virtual DbSet<Order> Orders { get; set; }
    public virtual DbSet<GetAllOrdersRequestDto> GetAllOrdersRequestDto { get; set; }

    public virtual DbSet<OrderItem> OrderItems { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    public virtual DbSet<ProductDto> ProductDto { get; set; }

    public virtual DbSet<ProductType> ProductTypes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)

        => optionsBuilder.UseSqlServer();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<DeliveryOption>(entity =>
        {
            entity.HasKey(e => e.DeliveryOptionId).HasName("PK__Delivery__A64074EA006CF48F");

            entity.Property(e => e.DeliveryOptionId).HasColumnName("DeliveryOptionID");
            entity.Property(e => e.DeliveryOptionName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.IsActive).HasDefaultValueSql("((1))");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Orders__C3905BAF603BF984");

            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.CustomerAddress)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.CustomerName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.DeliveryOptionId).HasColumnName("DeliveryOptionID");
            entity.Property(e => e.FulfillmentDate).HasColumnType("date");
            entity.Property(e => e.OrderDate).HasColumnType("date");

            entity.HasOne(d => d.DeliveryOption).WithMany(p => p.Orders)
                .HasForeignKey(d => d.DeliveryOptionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Orders__Delivery__2D27B809");
        });

        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.HasKey(e => e.OrderItemId).HasName("PK__OrderIte__57ED06A1DB5CC35D");

            entity.Property(e => e.OrderItemId).HasColumnName("OrderItemID");
            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.ProductId).HasColumnName("ProductID");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.OrderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__OrderItem__Order__300424B4");

            entity.HasOne(d => d.Product).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__OrderItem__Produ__30F848ED");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("PK__Products__B40CC6EDF58782B3");

            entity.HasIndex(e => e.ProductCode, "UQ__Products__2F4E024F10E5830B").IsUnique();

            entity.Property(e => e.ProductId).HasColumnName("ProductID");
            entity.Property(e => e.ProductCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ProductName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.ProductTypeId).HasColumnName("ProductTypeID");
            entity.Property(e => e.WarrantyDate).HasColumnType("date");

            entity.HasOne(d => d.ProductType).WithMany(p => p.Products)
                .HasForeignKey(d => d.ProductTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Products__Produc__2A4B4B5E");
        });

        modelBuilder.Entity<ProductType>(entity =>
        {
            entity.HasKey(e => e.ProductTypeId).HasName("PK__ProductT__A1312F4E7D45D1CF");

            entity.Property(e => e.ProductTypeId).HasColumnName("ProductTypeID");
            entity.Property(e => e.ProductTypeName)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
