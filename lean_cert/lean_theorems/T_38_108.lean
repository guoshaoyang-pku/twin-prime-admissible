import Sound
import lean_certs.cert_38_108

open CertVerify

theorem H38_gt_108 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 38) (d := 108) (c := cert_38_108) (by native_decide)
