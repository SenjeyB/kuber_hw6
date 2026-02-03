package ru.hse.muffin.wallet.server.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CurrencyRate {

  private String from;

  private String to;

  private BigDecimal rate;
}
