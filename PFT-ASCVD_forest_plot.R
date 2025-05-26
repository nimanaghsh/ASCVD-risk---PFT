library(readxl)
library(dplyr)
library(tidyr)
library(broom)
library(purrr)

# Load dataset
df <- read_excel("C:/Users/USER/Desktop/Projects/ASCVD/Mateo Dataset/Fourth set of analysis/Mateo_GLI modified.xlsx")

# Define variables
pulm_vars <- c("postfev1_pp", "postfvc_pp", "postfev1fvc_pp", "dlco_pp")
risk_models <- c("ascvdrisk", "preventascvd", "preventcvd", "preventhf")

# Model function — only returns estimate, CI, p
run_model <- function(pulm_var, risk_model, hiv_status) {
  df_sub <- df %>%
    filter(hiv == hiv_status) %>%
    mutate(
      INCOME = as.numeric(as.factor(INCOME)),
      BSEDUCTN = as.numeric(as.factor(BSEDUCTN)),
      hcv = as.numeric(as.factor(hcv)),
      BSCOCUSE = as.numeric(as.factor(BSCOCUSE)),
      CD4N_log = log(CD4N + 1),
      VLOAD_log = log(VLOAD + 1),
      HAARTV2 = as.numeric(as.factor(HAARTV2))
    )

  formula <- if (hiv_status == 1) {
    as.formula(paste(risk_model, "~", pulm_var, "+ CD4N_log + VLOAD_log + INCOME + BSEDUCTN + hcv + BSCOCUSE + HAARTV2"))
  } else {
    as.formula(paste(risk_model, "~", pulm_var, "+ INCOME + BSEDUCTN + hcv + BSCOCUSE"))
  }

  model <- lm(formula, data = df_sub)

  ci_vals <- confint(model)
  tidy_out <- tidy(model) %>% filter(term == pulm_var)

  tibble(
    estimate = tidy_out$estimate,
    conf.low = ci_vals[pulm_var, 1],
    conf.high = ci_vals[pulm_var, 2],
    p.value = tidy_out$p.value
  )
}

# Create combinations
grid <- expand_grid(
  pulmonary_variable = pulm_vars,
  risk_model = risk_models,
  hiv_status = c("HIV-negative", "HIV-positive")  # already as label
)

# Run models
summary_table <- grid %>%
  mutate(model_result = pmap(list(pulmonary_variable, risk_model, ifelse(hiv_status == "HIV-positive", 1, 0)), run_model)) %>%
  unnest(model_result)

# Show result
print(summary_table)

					-----------------------------------------------------------------------

Making forest plot

library(ggplot2)
library(dplyr)
library(forcats)

# Step 1: Reformat data
plot_data <- summary_table %>%
  mutate(
    pulm_label = recode(pulmonary_variable,
                        postfev1_pp = "Post-FEV1",
                        postfvc_pp = "Post-FVC",
                        postfev1fvc_pp = "Post-FEV1/FVC",
                        dlco_pp = "DLCO"),
    risk_label = recode(risk_model,
                        ascvdrisk = "10-year ASCVD",
                        preventascvd = "PREVENT-ASCVD",
                        preventcvd = "PREVENT-CVD",
                        preventhf = "PREVENT-HF"),
    hiv_color = ifelse(hiv_status == "HIV-positive", "HIV+", "HIV-"),
    p_label = ifelse(p.value < 0.001, "P < 0.001", paste0("P = ", formatC(p.value, format = "f", digits = 3))),
    p_label = ifelse(p.value < 0.05, paste0(p_label, "*"), p_label)
  )

# Set pulmonary variable order
plot_data$pulm_label <- factor(plot_data$pulm_label, levels = c("Post-FEV1", "Post-FVC", "Post-FEV1/FVC", "DLCO"))

# Step 2: Final plot
ggplot(plot_data, aes(x = estimate, y = pulm_label, color = hiv_color, shape = risk_label)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high),
                 height = 0.2, position = position_dodge(width = 0.7)) +
  geom_point(position = position_dodge(width = 0.7), size = 3) +
  scale_color_manual(values = c("HIV+" = "navy", "HIV-" = "cornflowerblue")) +
  scale_shape_manual(values = c(
    "ASCVD" = 15,
    "PREVENT-ASCVD" = 16,
    "PREVENT-CVD" = 17,
    "PREVENT-HF" = 18
  )) +
  labs(
    title = "",
    x = "Beta Coefficient (95% CI)",
    y = "",
    color = "HIV Status",
    shape = "CVD Risk Model"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(size = 12),
    plot.title = element_text(hjust = 0.5)
  )
