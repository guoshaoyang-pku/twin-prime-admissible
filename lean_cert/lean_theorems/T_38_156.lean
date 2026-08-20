import Sound
import lean_certs.cert_38_156

open CertVerify

theorem H38_gt_156 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 38) (d := 156) (c := cert_38_156) (by native_decide)
