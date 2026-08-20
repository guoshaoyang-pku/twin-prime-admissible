import Sound
import lean_certs.cert_38_116

open CertVerify

theorem H38_gt_116 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 38) (d := 116) (c := cert_38_116) (by native_decide)
