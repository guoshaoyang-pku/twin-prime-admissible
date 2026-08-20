import Sound
import lean_certs.cert_38_102

open CertVerify

theorem H38_gt_102 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 38) (d := 102) (c := cert_38_102) (by native_decide)
