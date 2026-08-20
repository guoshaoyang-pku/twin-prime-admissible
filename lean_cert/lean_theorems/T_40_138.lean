import Sound
import lean_certs.cert_40_138

open CertVerify

theorem H40_gt_138 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 40) (d := 138) (c := cert_40_138) (by native_decide)
