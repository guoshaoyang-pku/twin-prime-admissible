import Sound
import lean_certs.cert_40_134

open CertVerify

theorem H40_gt_134 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 40) (d := 134) (c := cert_40_134) (by native_decide)
