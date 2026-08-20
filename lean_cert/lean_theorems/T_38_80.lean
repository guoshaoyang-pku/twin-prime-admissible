import Sound
import lean_certs.cert_38_80

open CertVerify

theorem H38_gt_80 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 38) (d := 80) (c := cert_38_80) (by native_decide)
