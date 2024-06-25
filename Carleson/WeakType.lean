import Mathlib.MeasureTheory.Integral.MeanInequalities
import Mathlib.MeasureTheory.Integral.Layercake
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.Analysis.NormedSpace.Dual
import Mathlib.Analysis.NormedSpace.LinearIsometry

noncomputable section

open NNReal ENNReal NormedSpace MeasureTheory Set Filter Topology Function

variable {α α' 𝕜 E E₁ E₂ E₃ : Type*} {m : MeasurableSpace α} {m : MeasurableSpace α'}
  {p p' q : ℝ≥0∞} {c : ℝ≥0}
  {μ : Measure α} {ν : Measure α'} [NontriviallyNormedField 𝕜]
  [NormedAddCommGroup E] [NormedSpace 𝕜 E] [FiniteDimensional 𝕜 E]
  [NormedAddCommGroup E₁] [NormedSpace 𝕜 E₁] [FiniteDimensional 𝕜 E₁]
  [NormedAddCommGroup E₂] [NormedSpace 𝕜 E₂] [FiniteDimensional 𝕜 E₂]
  [NormedAddCommGroup E₃] [NormedSpace 𝕜 E₃] [FiniteDimensional 𝕜 E₃]
  [MeasurableSpace E] [BorelSpace E]
  [MeasurableSpace E₁] [BorelSpace E₁]
  [MeasurableSpace E₂] [BorelSpace E₂]
  [MeasurableSpace E₃] [BorelSpace E₃]
  (L : E₁ →L[𝕜] E₂ →L[𝕜] E₃)
  {f g : α → E} (hf : AEMeasurable f) {t s x y : ℝ≥0∞}
  {T : (α → E₁) → (α' → E₂)}

#check meas_ge_le_mul_pow_snorm -- Chebyshev's inequality

namespace MeasureTheory
/- If we need more properties of `E`, we can add `[RCLike E]` *instead of* the above type-classes-/
#check _root_.RCLike

/-! # The distribution function `d_f` -/

/-- The distribution function of a function `f`.
Note that unlike the notes, we also define this for `t = ∞`.
Note: we also want to use this for functions with codomain `ℝ≥0∞`, but for those we just write
`μ { x | t < f x }` -/
def distribution [NNNorm E] (f : α → E) (t : ℝ≥0∞) (μ : Measure α) : ℝ≥0∞ :=
  μ { x | t < ‖f x‖₊ }

@[gcongr] lemma distribution_mono_left (h : ∀ᵐ x ∂μ, ‖f x‖ ≤ ‖g x‖) :
    distribution f t μ ≤ distribution g t μ := sorry

@[gcongr] lemma distribution_mono_right (h : t ≤ s) :
    distribution f s μ ≤ distribution f t μ := sorry

@[gcongr] lemma distribution_mono (h : ∀ᵐ x ∂μ, ‖f x‖ ≤ ‖g x‖) (h : t ≤ s) :
    distribution f s μ ≤ distribution g t μ := sorry

lemma distribution_smul_left {c : 𝕜} (hc : c ≠ 0) :
    distribution (c • f) t μ = distribution f (t / ‖c‖₊) μ := sorry

lemma distribution_add_le :
    distribution (f + g) (t + s) μ ≤ distribution f t μ + distribution g s μ := sorry

lemma _root_.ContinuousLinearMap.distribution_le {f : α → E₁} {g : α → E₂} :
    distribution (fun x ↦ L (f x) (g x)) (‖L‖₊ * t * s) μ ≤
    distribution f t μ + distribution g s μ := sorry


/- A version of the layer-cake theorem already exists, but the need the versions below. -/
#check MeasureTheory.lintegral_comp_eq_lintegral_meas_lt_mul

/-- The layer-cake theorem, or Cavalieri's principle for functions into `ℝ≥0∞` -/
lemma lintegral_norm_pow_eq_measure_lt {f : α → ℝ≥0∞} (hf : AEMeasurable f μ)
    {p : ℝ} (hp : 1 ≤ p) :
    ∫⁻ x, (f x) ^ p ∂μ =
    ∫⁻ t in Ioi (0 : ℝ), ENNReal.ofReal (p * t ^ (p - 1)) * μ { x | ENNReal.ofReal t < f x } := by
  sorry

/-- The layer-cake theorem, or Cavalieri's principle for functions into a normed group. -/
lemma lintegral_norm_pow_eq_distribution {p : ℝ} (hp : 1 ≤ p) :
    ∫⁻ x, ‖f x‖₊ ^ p ∂μ =
    ∫⁻ t in Ioi (0 : ℝ), ENNReal.ofReal (p * t ^ (p - 1)) * distribution f (.ofReal t) μ := sorry

/-- The layer-cake theorem, or Cavalieri's principle, written using `snorm`. -/
lemma snorm_pow_eq_distribution {p : ℝ≥0} (hp : 1 ≤ p) :
    snorm f p μ ^ (p : ℝ) =
    ∫⁻ t in Ioi (0 : ℝ), p * ENNReal.ofReal (t ^ ((p : ℝ) - 1)) * distribution f (.ofReal t) μ := by
  sorry

lemma lintegral_pow_mul_distribution {p : ℝ} (hp : 1 ≤ p) :
    ∫⁻ t in Ioi (0 : ℝ), ENNReal.ofReal (t ^ p) * distribution f (.ofReal t) μ =
    ENNReal.ofReal p⁻¹ * ∫⁻ x, ‖f x‖₊ ^ (p + 1) ∂μ  := sorry


/-- The weak L^p norm of a function, for `p < ∞` -/
def wnorm' [NNNorm E] (f : α → E) (p : ℝ) (μ : Measure α) : ℝ≥0∞ :=
  ⨆ t : ℝ≥0, t * distribution f t μ ^ (p : ℝ)⁻¹

lemma wnorm'_le_snorm' {f : α → E} (hf : AEStronglyMeasurable f μ) {p : ℝ} (hp : 1 ≤ p) :
    wnorm' f p μ ≤ snorm' f p μ := sorry

/-- The weak L^p norm of a function. -/
def wnorm [NNNorm E] (f : α → E) (p : ℝ≥0∞) (μ : Measure α) : ℝ≥0∞ :=
  if p = ∞ then snormEssSup f μ else wnorm' f (ENNReal.toReal p) μ

lemma wnorm_le_snorm {f : α → E} (hf : AEStronglyMeasurable f μ) {p : ℝ≥0∞} (hp : 1 ≤ p) :
    wnorm f p μ ≤ snorm f p μ := sorry

/-- A function is in weak-L^p if it is (strongly a.e.)-measurable and has finite weak L^p norm. -/
def MemWℒp [NNNorm E] (f : α → E) (p : ℝ≥0∞) (μ : Measure α) : Prop :=
  AEStronglyMeasurable f μ ∧ wnorm f p μ < ∞

lemma Memℒp.memWℒp {f : α → E} {p : ℝ≥0∞} (hp : 1 ≤ p) (hf : Memℒp f p μ) :
    MemWℒp f p μ := sorry

/- Todo: define `MeasureTheory.WLp` as a subgroup, similar to `MeasureTheory.Lp` -/

/-- An operator has weak type `(p, q)` if it is bounded as a map from L^p to weak-L^q.
`HasWeakType T p p' μ ν c` means that `T` has weak type (p, q) w.r.t. measures `μ`, `ν`
and constant `c`.  -/
def HasWeakType (T : (α → E₁) → (α' → E₂)) (p p' : ℝ≥0∞) (μ : Measure α) (ν : Measure α')
    (c : ℝ≥0) : Prop :=
  ∀ f : α → E₁, Memℒp f p μ → AEStronglyMeasurable (T f) ν ∧ wnorm (T f) p' ν ≤ c * snorm f p μ

/-- An operator has strong type (p, q) if it is bounded as an operator on `L^p → L^q`.
`HasStrongType T p p' μ ν c` means that `T` has strong type (p, q) w.r.t. measures `μ`, `ν`
and constant `c`.  -/
def HasStrongType {E E' α α' : Type*} [NormedAddCommGroup E] [NormedAddCommGroup E']
    {_x : MeasurableSpace α} {_x' : MeasurableSpace α'} (T : (α → E) → (α' → E'))
    (p p' : ℝ≥0∞) (μ : Measure α) (ν : Measure α') (c : ℝ≥0) : Prop :=
  ∀ f : α → E, Memℒp f p μ → AEStronglyMeasurable (T f) ν ∧ snorm (T f) p' ν ≤ c * snorm f p μ

/-- A weaker version of `HasStrongType`. This is the same as `HasStrongType` if `T` is continuous
w.r.t. the L^2 norm, but weaker in general. -/
def HasBoundedStrongType {E E' α α' : Type*} [NormedAddCommGroup E] [NormedAddCommGroup E']
    {_x : MeasurableSpace α} {_x' : MeasurableSpace α'} (T : (α → E) → (α' → E'))
    (p p' : ℝ≥0∞) (μ : Measure α) (ν : Measure α') (c : ℝ≥0) : Prop :=
  ∀ f : α → E, Memℒp f p μ → snorm f ∞ μ < ∞ → μ (support f) < ∞ →
  AEStronglyMeasurable (T f) ν ∧ snorm (T f) p' ν ≤ c * snorm f p μ


lemma HasStrongType.hasWeakType (hp : 1 ≤ p)
    (h : HasStrongType T p p' μ ν c) : HasWeakType T p p' μ ν c := by
  sorry

lemma HasStrongType.hasBoundedStrongType (h : HasStrongType T p p' μ ν c) :
    HasBoundedStrongType T p p' μ ν c :=
  fun f hf _ _ ↦ h f hf


end MeasureTheory
