import Sound
import lean_certs.cert_38_138

open CertVerify

theorem H38_gt_138 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 38) (d := 138) (c := cert_38_138) (by native_decide)
